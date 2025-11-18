import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/cubit/game_state_cubit.dart';
import 'package:flutter_factory/cubit/game_state.dart';
import 'package:flutter_factory/object/game_object.dart';

class GameIsolate {
  late Isolate isolate;
  late ReceivePort receivePort;
  late Stream broadcastStream;
  // late SendPort sendPort;

  final Completer<SendPort> _sendPortCompleter = Completer<SendPort>();

  static final GameIsolate _instance = GameIsolate._();
  bool started = false;

  factory GameIsolate() {
    return _instance;
  }

  GameIsolate._() {
    receivePort = ReceivePort();
    broadcastStream = receivePort.asBroadcastStream();
  }

  void start(GameState initialState) async {
    if (started) return;
    started = true;

    isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);

    SendPort sendPort = await broadcastStream.first;
    sendPort.send(initialState);
    _sendPortCompleter.complete(sendPort);
  }

  void sendMessage(GameEvent event) async {
    SendPort sendPort = await _sendPortCompleter.future;
    sendPort.send(event);
  }

  void listen(void Function(GameState message) onData) {
    broadcastStream.listen((dynamic message) {
      if (message is GameState) {
        onData(message);
      } else {
        print("Received non-GameState message in main isolate");
      }
    });
  }

  static GameState _currentState = GameState(gameObjects: SplayTreeMap<int, Map<String, GameObject>>());
  static late final SendPort _sendPort;

  static final StreamController<GameEvent> _eventBus =
      StreamController<GameEvent>.broadcast();

  static void _isolateEntry(SendPort sendPort) {
    // Initialize the isolate
    _sendPort = sendPort;
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    // Listen for messages from the main isolate
    receivePort.listen(_handleMessage);
    _eventBus.stream.listen(_handleEventBus);

    //Game Loop
    startGameLoop();
  }

  static bool _isRunning = false;
  static double _deltaTime = 0;
  static int _lastUpdateTime = DateTime.now().microsecondsSinceEpoch;

  static final int _ticksPerSecond = 60;
  static final int _tickDuration = (1000000 / _ticksPerSecond).round();

  static void startGameLoop() {
    if (!_isRunning) {
      _isRunning = true;
      _lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
      _gameLoop();
    }
  }

  static void _gameLoop() {
    // print("Game Loop Tick ${DateTime.now()}");
    int currentTime = DateTime.now().microsecondsSinceEpoch;
    _deltaTime = (currentTime - _lastUpdateTime) / 1e6; // in seconds
    _lastUpdateTime = currentTime;

    // Update game objects
    for (var gameObject in _currentState.gameObjects.values.expand((map) => map.values)) {
      gameObject.onTick(_deltaTime, _eventBus);
    }
    int currentTimeEnd = DateTime.now().microsecondsSinceEpoch;

    // Schedule the next update
    if (_isRunning) {
      Future.delayed(
        Duration(
          microseconds: (_tickDuration - (currentTimeEnd - currentTime)),
        ),
        _gameLoop,
      );
    }
  }

  static void _handleEventBus(GameEvent event) {
    switch (event) {
      case HandlerEvent():
        _currentState = event.handle(_currentState, _eventBus);
        break;
      case GameEvent():
        // _eventBus.add(event);
        break;
    }
    _sendPort.send(_currentState);
  }

  static void _handleMessage(dynamic message) {
    // Handle incoming messages
    if (message is String) {
      print("Isolate received: $message");
    }
    if (message is GameState) {
      _currentState = message;

      for (var gameObject in _currentState.gameObjects.values.expand(
        (map) => map.values,
      )) {
        gameObject.unregisterListeners();
        gameObject.registerListeners(_eventBus);
      }

      _sendPort.send(_currentState);
      return;
    }
    if (message is! GameEvent) {
      print("Isolate received non-GameEvent message");
      return;
    }
    GameEvent event = message;

    switch (event) {
      case HandlerEvent():
        _currentState = event.handle(_currentState, _eventBus);
        break;
      case GameEvent():
        _eventBus.add(event);
        break;
    }

    _sendPort.send(_currentState);
  }
}
