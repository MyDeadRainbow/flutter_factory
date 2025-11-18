import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/cubit/game_state_cubit.dart';
import 'package:flutter_factory/object/game_object.dart';
import 'package:provider/provider.dart';

class InputListener extends StatefulWidget {
  final Widget child;

  const InputListener({
    super.key,
    required this.child,
  });

  @override
  State<InputListener> createState() => _InputListenerState();
}

class _InputListenerState extends State<InputListener> {
  final Set<LogicalKeyboardKey> pressedKeys = {};

  bool inputLoopRunning = false;

  void startInputLoop(GameStateCubit cubit) {
    if (inputLoopRunning) return;
    inputLoopRunning = true;
    Future.doWhile(() async {
      final startTime = DateTime.now();
      for (final input in pressedKeys) {
        cubit.submitEvent(KeyboardGameEvent(logicalKey: input));
      }
      final endTime = DateTime.now();
      final deltaTime = endTime.difference(startTime).inMilliseconds / 1000.0;
      final waitTime = (16.67 - deltaTime * 1000).clamp(0, double.infinity);
      await Future.delayed(Duration(milliseconds: waitTime.toInt()));
      return inputLoopRunning;
    });
  }

  @override
  void dispose() {    
    super.dispose();
    inputLoopRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    startInputLoop(context.read<GameStateCubit>());
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove:
          (event) => context.read<GameStateCubit>().submitEvent(
            PointerGameEvent(
              pointerEvent: event,
              viewportSize: MediaQuery.of(context).size,
              zoom: context.read<GameStateCubit>().state.zoom,
              centerOffset: context.read<GameStateCubit>().state.centerOffset
            ),
          ), //_updateCharacterRotation(context, event),
      onPointerHover:
          (event) => context.read<GameStateCubit>().submitEvent(
            PointerGameEvent(
              pointerEvent: event,
              viewportSize: MediaQuery.of(context).size,
              zoom: context.read<GameStateCubit>().state.zoom,
              centerOffset: context.read<GameStateCubit>().state.centerOffset
            ),
          ), //_updateCharacterRotation(context, event),
      onPointerSignal:
          (event) => context.read<GameStateCubit>().submitEvent(
            PointerGameEvent(
              pointerEvent: event,
              viewportSize: MediaQuery.of(context).size,
              zoom: context.read<GameStateCubit>().state.zoom,
              centerOffset: context.read<GameStateCubit>().state.centerOffset
            ),
          ),
      child: Focus(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: (node, event) {
          // print('Event: $event Key: ${event.logicalKey}');
          if (event is KeyDownEvent) {
            pressedKeys.add(event.logicalKey);
          }
          if (event is KeyUpEvent) {
            pressedKeys.remove(event.logicalKey);
          }
          return KeyEventResult.ignored;
        },
        child: widget.child,
      ),
    );
  }
}
