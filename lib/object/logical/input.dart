import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/cubit/game_state/game_state.dart';
import 'package:flutter_factory/cubit/input_state/input_state.dart';
import 'package:flutter_factory/object/game_object.dart';

class KeyboardInput extends GameObject {
  KeyboardInput({
    super.size = Size.zero,
    super.position = Offset.zero,
    super.rotation = 0.0,
    super.z = 0,
  }) {
    on<KeyboardGameEvent>((event, eventBus) {
      if (event.keyEvent is KeyDownEvent) {
        InputState.current.keyboardInputState.pressedKeys.add(event.logicalKey);
      }
      if (event.keyEvent is KeyUpEvent) {
        InputState.current.keyboardInputState.pressedKeys.remove(
          event.logicalKey,
        );
      }
    });
  }
}

class PointerInput extends GameObject {
  PointerInput({
    super.size = Size.zero,
    super.position = Offset.zero,
    super.rotation = 0.0,
    super.z = 0,
  }) {
    on<PointerGameEvent>((event, eventBus) {
      InputState.current.pointerInputState.pointerPosition =
          event.pointerEvent.position;
      InputState.current.pointerInputState.viewportSize = event.viewportSize;
      if (event.pointerEvent is PointerDownEvent) {
        InputState.current.pointerInputState.pressedButtons.add(
          (event.pointerEvent as PointerDownEvent).buttons,
        );
      }
      if (event.pointerEvent is PointerMoveEvent) {
        InputState.current.pointerInputState.pressedButtons.add(
          (event.pointerEvent as PointerMoveEvent).buttons,
        );
      }
      if (event.pointerEvent is PointerHoverEvent) {
        InputState.current.pointerInputState.pressedButtons.clear();
      }
    });
  }
}

class Zoom extends GameObject {
  Zoom({
    super.size = Size.zero,
    super.position = Offset.zero,
    super.rotation = 0.0,
    super.uid = 'zoom_listener',
    super.z = 0,
  }) {
    on<PointerGameEvent>((event, eventBus) {
      if (event.pointerEvent is PointerScrollEvent) {
        final scrollEvent = event.pointerEvent as PointerScrollEvent;
        GameState.current.zoom += (scrollEvent.scrollDelta.dy * -0.0001);
      }
    });
  }
}
