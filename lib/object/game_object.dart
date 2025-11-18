import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:uuid/uuid.dart';

abstract class GameObject {
  final String uid;
  final int z;
  Size size;
  Offset position;
  double rotation;
  final Map<Type, Function(GameEvent, StreamController<GameEvent>)>
  eventHandlers = {};

  final List<StreamSubscription> _subscriptions = [];

  GameObject({
    required this.size,
    required this.z,
    required this.position,
    required this.rotation,
    String? uid,
  }) : uid = uid ?? const Uuid().v4();

  void registerListeners(StreamController<GameEvent> eventBus) {
    _subscriptions.add(
      eventBus.stream.listen((event) {
        final handler = eventHandlers[event.runtimeType];
        if (handler != null) {
          handler(event, eventBus);
        }
      }),
    );
  }

  void unregisterListeners() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  void onTick(double deltaTime, StreamController<GameEvent> eventBus);

  void render(Canvas canvas);

  void on<T extends GameEvent>(
    Function(T event, StreamController<GameEvent> eventBus) handler,
  ) {
    eventHandlers[T] = (event, eventBus) => handler(event as T, eventBus);
  }

  void paint(Canvas canvas, Size size, double zoom, Offset centerOffset) {
    canvas.save();
    canvas.translate(
      size.width / 2 + (centerOffset.dx + position.dx * zoom),
      size.height / 2 - (centerOffset.dy + position.dy * zoom),
    );
    canvas.scale(zoom);
    render(canvas);
    canvas.restore();
  }

  @override
  String toString() =>
      'GameObject(size: $size, position: $position, rotation: $rotation)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameObject &&
        other.runtimeType == runtimeType &&
        other.size == size &&
        other.position == position &&
        other.rotation == rotation;
  }

  @override
  int get hashCode => size.hashCode ^ position.hashCode ^ rotation.hashCode;
}
