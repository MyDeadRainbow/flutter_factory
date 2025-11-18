import 'dart:collection';

import 'package:flutter/semantics.dart';
import 'package:flutter_factory/object/game_object.dart';

class GameState {
  static const kGridSize = 50;

  double zoom;

  final SplayTreeMap<int, Map<String, GameObject>> gameObjects;

  Offset centerOffset;

  GameState({this.zoom = 1, required this.gameObjects, this.centerOffset = Offset.zero});

  // GameState copyWith({double? zoom, SplayTreeMap<int, Map<String, GameObject>>? gameObjects, Offset? centerOffset}) {
  //   return GameState(
  //     zoom: zoom ?? this.zoom,
  //     gameObjects: gameObjects ?? this.gameObjects,
  //     centerOffset: centerOffset ?? this.centerOffset,
  //   );
  // }
}
