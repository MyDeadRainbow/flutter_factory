import 'dart:async';

import 'dart:ui';

import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/cubit/game_state/game_state.dart';
import 'package:flutter_factory/object/game_object.dart';

class Camera extends GameObject with Tickable {
  Offset targetPosition;
  double panSpeed;

  Camera({
    required this.targetPosition,
    required super.position,
    super.rotation = 0,
    super.z = 2000,
    this.panSpeed = 100,
    super.uid = 'camera',
  }) : super(size: Size.zero) {
    on<CharacterMoveEvent>((event, eventBus) {
      // final newGameObject = this.copyWith(
      //   targetPosition: this.targetPosition + event.delta,
      // );
      // eventBus.add(
      //   UpdateGameObject(oldGameObject: this, newGameObject: newGameObject)
      // );
      targetPosition = event.characterPosition;
    });
  }

  @override
  void onTick(double deltaTime, StreamController<GameEvent> eventBus) {
    final direction = - targetPosition - position;
    final distance = direction.distance;
    Offset newPosition = position;
    if (distance > 1) {
      final moveDistance = panSpeed * deltaTime;
      final moveVector = Offset(
        direction.dx / distance * moveDistance,
        direction.dy / distance * moveDistance,
      );

      newPosition += moveVector;
    }
    //  else {
    //   newPosition = targetPosition;a
    // }
    if (newPosition == position) {
      return;
    }
    position = newPosition;
    // eventBus.add(
    //   UpdateGameObject(
    //     oldGameObject: this,
    //     newGameObject: this.copyWith(position: newPosition),
    //   ),
    // );
    GameState.current.centerOffset = newPosition;
    // eventBus.add(
    //   ModifyStateEvent(
    //     modify: (state) => state..centerOffset = newPosition,
    //     // state.copyWith(
    //     //   centerOffset: newPosition,
    //     // ),
    //   ),
    // );
  }

  Camera copyWith({
    Offset? targetPosition,
    Offset? position,
    double? rotation,
    int? z,
    double? panSpeed,
  }) {
    return Camera(
      targetPosition: targetPosition ?? this.targetPosition,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      z: z ?? this.z,
      panSpeed: panSpeed ?? this.panSpeed,
    );
  }
}
