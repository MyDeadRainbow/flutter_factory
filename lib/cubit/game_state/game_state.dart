import 'dart:collection';

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_factory/object/game_object.dart';

class GameState {
  static GameState current = GameState(
    gameObjects: SplayTreeMap<int, Map<String, GameObject>>(),
  );

  static const kGridSize = 50;


  final SplayTreeMap<int, Map<String, GameObject>> gameObjects;

  Offset centerOffset;
  double zoom = 1;

  GameState({
    required this.gameObjects,
    this.centerOffset = Offset.zero,
  });

  // GameState copyWith({double? zoom, SplayTreeMap<int, Map<String, GameObject>>? gameObjects, Offset? centerOffset}) {
  //   return GameState(
  //     zoom: zoom ?? this.zoom,
  //     gameObjects: gameObjects ?? this.gameObjects,
  //     centerOffset: centerOffset ?? this.centerOffset,
  //   );
  // }
}

