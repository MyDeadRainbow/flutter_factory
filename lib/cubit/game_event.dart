import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_factory/cubit/game_state/game_state.dart';
import 'package:flutter_factory/object/game_object.dart';

abstract class GameEvent {}

abstract class HandlerEvent extends GameEvent {
  GameState handle(GameState state, StreamController<GameEvent> eventBus);
}

class KeyboardGameEvent extends GameEvent {
  final KeyEvent keyEvent;
  final LogicalKeyboardKey logicalKey;

  KeyboardGameEvent({required this.keyEvent, required this.logicalKey});
}

class PointerGameEvent extends GameEvent {
  final PointerEvent pointerEvent;
  final Size viewportSize;
  final double zoom;
  final Offset centerOffset;

  PointerGameEvent({required this.pointerEvent, required this.viewportSize, required this.zoom, required this.centerOffset});
}

class InputEvent extends GameEvent {
  final String inputType;
  final dynamic data;

  InputEvent({required this.inputType, this.data});
}

class AddGameObject extends HandlerEvent {
  final GameObject gameObject;

  AddGameObject({required this.gameObject});

  @override
  GameState handle(GameState state, StreamController<GameEvent> eventBus) {
    state.gameObjects[gameObject.z] ??= {};
    state.gameObjects[gameObject.z]![gameObject.uid] = gameObject;
    return state;
  }
}

class RemoveGameObject extends HandlerEvent {
  final GameObject gameObject;
  RemoveGameObject({required this.gameObject});

  @override
  GameState handle(GameState state, StreamController<GameEvent> eventBus) {
    state.gameObjects[gameObject.z]?.remove(gameObject.uid);

    return state;
  }
}

class UpdateGameObject extends HandlerEvent {
  final GameObject oldGameObject;
  final GameObject newGameObject;

  UpdateGameObject({required this.oldGameObject, required this.newGameObject});

  @override
  GameState handle(GameState state, StreamController<GameEvent> eventBus) {
    state.gameObjects[oldGameObject.z]?.remove(oldGameObject.uid);
    state.gameObjects[newGameObject.z] ??= {};
    state.gameObjects[newGameObject.z]![newGameObject.uid] = newGameObject;

    // GameState newState = state.copyWith(gameObjects: state.gameObjects);
    oldGameObject.unregisterListeners();
    newGameObject.registerListeners(eventBus);
    return state;
  }
}

class ModifyStateEvent extends HandlerEvent {
  final GameState Function(GameState state) modify;

  ModifyStateEvent({required this.modify});

  @override
  GameState handle(GameState state, StreamController<GameEvent> eventBus) {
    GameState newState = modify(state);
    return newState;
  }
}

class CharacterMoveEvent extends GameEvent {
  final Offset characterPosition;

  CharacterMoveEvent({required this.characterPosition});
}

// class ChangeZoomEvent extends HandlerEvent {
//   final double amount;

//   ChangeZoomEvent({required this.amount});

//   @override
//   GameState handle(GameState state, StreamController<GameEvent> eventBus) {
//     GameState newState = state.copyWith(zoom: state.zoom + amount);
//     return newState;
//   }
// }
