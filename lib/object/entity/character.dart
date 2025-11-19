import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/cubit/game_state/game_state.dart';
import 'package:flutter_factory/cubit/input_state/input_state.dart';
import 'package:flutter_factory/object/game_object.dart';

class Character extends GameObject with Tickable, Renderable {
  final Map<String, Character Function(double deltaTime, Character current)>
  inputStream = {};

  final double speed = 100; // units per second

  Character({
    required super.size,
    required super.position,
    required super.rotation,
    super.z = 1000,
    super.uid = 'character',
  });

  @override
  void onTick(
    double deltaTime,
    StreamController<GameEvent> eventBus,
  ) {
    Character old = this;
    final pointerPos = InputState.current.pointerInputState.pointerPosition;
    final viewportSize = InputState.current.pointerInputState.viewportSize;
    final centerX =
        viewportSize.width / 2 +
        (old.position.dx + GameState.current.centerOffset.dx) * GameState.current.zoom;
    final centerY =
        viewportSize.height / 2 -
        (old.position.dy + GameState.current.centerOffset.dy) * GameState.current.zoom;
    final dx = pointerPos.dx - centerX;
    final dy = pointerPos.dy - centerY;
    final rotation = (math.atan2(dy, dx) + math.pi / 2) % (2 * math.pi);
    this.rotation = rotation;

    for (var key in InputState.current.keyboardInputState.pressedKeys) {
      switch (key) {
        case LogicalKeyboardKey.keyW || LogicalKeyboardKey.arrowUp:
          position += Offset(0, speed * deltaTime);
          break;
        case LogicalKeyboardKey.keyA || LogicalKeyboardKey.arrowLeft:
          position += Offset(-speed * deltaTime, 0);
          break;
        case LogicalKeyboardKey.keyS || LogicalKeyboardKey.arrowDown:
          position += Offset(0, -speed * deltaTime);
          break;
        case LogicalKeyboardKey.keyD || LogicalKeyboardKey.arrowRight:
          position += Offset(speed * deltaTime, 0);
          break;
        default:
          break;
      }
    }
    // for (var action in inputStream.values) {
    //   old = action(deltaTime, old);
    // }
    // if (inputStream.isNotEmpty) {
    //   // eventBus.add(UpdateGameObject(oldGameObject: this, newGameObject: old));
    eventBus.add(CharacterMoveEvent(characterPosition: position));
    // }
    inputStream.clear();
  }

  @override
  void render(Canvas canvas) {
    // render arrow as placeholder
    final paint = Paint()..color = Colors.blue;

    canvas.rotate(rotation);
    final path = Path();
    path.moveTo(0, -this.size.height / 2);
    path.lineTo(this.size.width / 2, this.size.height / 2);
    path.lineTo(-this.size.width / 2, this.size.height / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  // Character copyWith({Size? size, Offset? position, double? rotation}) {
  //   return Character(
  //     size: size ?? this.size,
  //     position: position ?? this.position,
  //     rotation: rotation ?? this.rotation,
  //   );
  // }
}
