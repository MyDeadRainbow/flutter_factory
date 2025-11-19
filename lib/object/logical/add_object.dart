
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/cubit/game_state/game_state.dart';
import 'package:flutter_factory/cubit/input_state/input_state.dart';
import 'package:flutter_factory/object/entity/block.dart';
import 'package:flutter_factory/object/game_object.dart';

class AddObject extends GameObject with Tickable {
  AddObject({
    super.size = Size.zero,
    super.position = Offset.zero,
    super.rotation = 0.0,
    super.uid = 'add_object',
    super.z = 0,
  });

  @override
  void onTick(
    double deltaTime,
    StreamController<GameEvent> eventBus,
  ) {
    if (!InputState.current.pointerInputState.pressedButtons.contains(kPrimaryMouseButton)) {
      return;
    }
    
    Offset pointerPos = InputState.current.pointerInputState.pointerPosition;
    Size viewportSize = InputState.current.pointerInputState.viewportSize;
    double zoom = GameState.current.zoom;
    Offset centerOffset = GameState.current.centerOffset;
    
    var posX =
        (pointerPos.dx - viewportSize.width / 2) / zoom - centerOffset.dx;
    var posY =
        -(pointerPos.dy - viewportSize.height / 2) / zoom - centerOffset.dy;
    posX = (posX / GameState.kGridSize).roundToDouble() * GameState.kGridSize;
    posY = (posY / GameState.kGridSize).roundToDouble() * GameState.kGridSize;
    eventBus.add(
      AddGameObject(
        gameObject: Block(size: Size(50, 50), position: Offset(posX, posY)),
      ),
    );
  }
}