import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_factory/cubit/game_event.dart';
import 'package:flutter_factory/cubit/game_isolate.dart';
import 'package:flutter_factory/cubit/game_state/game_state.dart';
import 'package:flutter_factory/object/game_object.dart';

class GameStateCubit extends Cubit<GameState> {
  GameIsolate gameIsolate = GameIsolate();

  GameStateCubit(super.initialState) {
    gameIsolate.start(state);
    gameIsolate.listen((GameState message) {
      emit(message);
    });
    // on<AddGameObject>((event, emit) {
    //   gameIsolate.sendMessage(event);
    // });

    // on<RemoveGameObject>((event, emit) {
    //   gameIsolate.sendMessage(event);
    // });

    // on<ChangeZoomEvent>((event, emit) => emit(state..zoom += event.amount));
  }

  void submitEvent(GameEvent event) {
    gameIsolate.sendMessage(event);
  }
}
