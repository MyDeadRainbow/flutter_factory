

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/object/game_object.dart';

class Character extends GameObject {
  final Map<String, Character Function(double deltaTime, Character current)>
  inputStream = {};

  final double speed = 100; // units per second

  Character({
    required super.size,
    required super.position,
    required super.rotation,
    super.z = 1000,
    super.uid = 'character',
  }) {
    on<KeyboardGameEvent>((event, eventBus) {
      
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyW || LogicalKeyboardKey.arrowUp:
          inputStream['move_up'] = (deltaTime, old) {
            position += Offset(0, speed * deltaTime);
            // Character updated = old.copyWith(
            //   position: old.position + Offset(0, speed * deltaTime),
            // );
            // Character(
            //   size: old.size,
            //   position: old.position + Offset(0, speed * deltaTime),
            //   rotation: old.rotation,
            // );
            return this;
          };
          break;
        case LogicalKeyboardKey.keyA || LogicalKeyboardKey.arrowLeft:
          inputStream['move_left'] = (deltaTime, old) {
            // Character updated = old.copyWith(
            //   position: old.position + Offset(-speed * deltaTime, 0),
            // );
            // Character(
            //   size: old.size,
            //   position: old.position + Offset(-speed * deltaTime, 0),
            //   rotation: old.rotation,
            // );
            position += Offset(-speed * deltaTime, 0);
            Character updated = this;
            return updated;
          };
          break;
        case LogicalKeyboardKey.keyS || LogicalKeyboardKey.arrowDown:
          inputStream['move_down'] = (deltaTime, old) {
            // Character updated = old.copyWith(
            //   position: old.position + Offset(0, -speed * deltaTime),
            // );
            // Character(
            //   size: old.size,
            //   position: old.position + Offset(0, -speed * deltaTime),
            //   rotation: old.rotation,
            // );
            position += Offset(0, -speed * deltaTime);
            Character updated = this;
            return updated;
          };
          break;
        case LogicalKeyboardKey.keyD || LogicalKeyboardKey.arrowRight:
          inputStream['move_right'] = (deltaTime, old) {
            // Character updated = old.copyWith(
            //   position: old.position + Offset(speed * deltaTime, 0),
            // );
            // Character(
            //   size: old.size,
            //   position: old.position + Offset(speed * deltaTime, 0),
            //   rotation: old.rotation,
            // );
            position += Offset(speed * deltaTime, 0);
            Character updated = this;
            return updated;
          };
          break;
        default:
          break;
      }
    });

    on<PointerGameEvent>((event, eventBus) {
      inputStream['rotate'] = (deltaTime, old) {
        final pointerPos = event.pointerEvent.position;
        final viewportSize = event.viewportSize;
        final centerX =
            viewportSize.width / 2 +
            (old.position.dx + event.centerOffset.dx) * event.zoom; //viewportSize.width / 2;
        final centerY =
            viewportSize.height / 2 -
            (old.position.dy + event.centerOffset.dy) * event.zoom; //viewportSize.height / 2;
        final dx = pointerPos.dx - centerX;
        final dy = pointerPos.dy - centerY;
        final rotation = (math.atan2(dy, dx) + math.pi / 2) % (2 * math.pi);
        // Character updated = old.copyWith(rotation: rotation);
        Character updated = this;
        this.rotation = rotation;
        return updated;
      };
    });
  }

  @override
  void onTick(double deltaTime, StreamController<GameEvent> eventBus) {
    Character old = this;
    for (var action in inputStream.values) {
      old = action(deltaTime, old);
    }
    if (inputStream.isNotEmpty) {
      // eventBus.add(UpdateGameObject(oldGameObject: this, newGameObject: old));
      eventBus.add(CharacterMoveEvent(characterPosition: old.position));
    }
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
