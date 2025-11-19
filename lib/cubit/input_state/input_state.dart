import 'package:flutter/services.dart';

class InputState {
  static InputState current = InputState();

  KeyboardInputState keyboardInputState = KeyboardInputState();
  PointerInputState pointerInputState = PointerInputState();
}


class KeyboardInputState {
  final Set<LogicalKeyboardKey> pressedKeys = {};

  KeyboardInputState();
}

class PointerInputState {
  Offset pointerPosition = Offset.zero;
  final Set<int> pressedButtons = {};
  Size viewportSize = Size.zero;

  PointerInputState();
}