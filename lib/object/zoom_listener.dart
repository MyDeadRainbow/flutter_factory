import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/object/game_object.dart';

class ZoomListener extends GameObject {
  ZoomListener({
    super.size = Size.zero,
    super.position = Offset.zero,
    super.rotation = 0.0,
    super.uid = 'zoom_listener',
    super.z = 0,
  }) {
    on<PointerGameEvent>((event, eventBus) {
      if (event.pointerEvent is PointerScrollEvent) {
        final scrollEvent = event.pointerEvent as PointerScrollEvent;
        eventBus.add(
          ModifyStateEvent(
            modify:
                (state) => state..zoom += (scrollEvent.scrollDelta.dy * -0.0001),
                // copyWith(
                //   zoom: state.zoom + (scrollEvent.scrollDelta.dy * -0.0001),
                // ),
          ),
        );
      }
    });
  }

  @override
  void onTick(double deltaTime, StreamController<GameEvent> eventBus) {}

  @override
  void render(Canvas canvas) {}
}
