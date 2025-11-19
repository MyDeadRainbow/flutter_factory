import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/cubit/game_state/game_state.dart';
import 'package:flutter_factory/object/game_object.dart';

class Block extends GameObject with Renderable {
  Block({required super.size, required super.position, super.rotation = 0.0, super.z = 0});

  @override
  void render(Canvas canvas) {
    final paint =
        Paint()
          ..color = Colors.brown
          ..style = PaintingStyle.fill;
    final rect = Rect.fromCenter(
      center: Offset(0, 0),
      width: this.size.width + 1,
      height: this.size.height + 1,
    );
    canvas.drawRect(rect, paint);
  }

  Block copyWith({Size? size, Offset? position, double? rotation}) {
    return Block(
      size: size ?? this.size,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
    );
  }
}
