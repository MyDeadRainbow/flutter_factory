import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_factory/cubit/game_state_cubit.dart';
import 'package:flutter_factory/object/game_object.dart';

class GamePainter extends CustomPainter {
  final Iterable<GameObject> gameObjects;
  final double zoom;
  final Offset centerOffset;

  GamePainter({
    this.gameObjects = const [],
    this.zoom = 1.0,
    this.centerOffset = Offset.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black, BlendMode.srcOver);
    for (final gameObject in gameObjects) {
      gameObject.paint(canvas, size, zoom, centerOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GamePaint extends StatelessWidget {
  final double width;
  final double height;

  const GamePaint({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(width, height),
        painter: GamePainter(
          gameObjects: context
              .watch<GameStateCubit>()
              .state
              .gameObjects
              .values
              .expand((map) => map.values),
          zoom: context.watch<GameStateCubit>().state.zoom,
          centerOffset: context.watch<GameStateCubit>().state.centerOffset,
        ),
      ),
    );
  }
}

// abstract interface class GameObject {
//   final double size;
//   final Offset position;

//   GameObject({required this.size, required this.position});

//   void _render(Canvas canvas);

//   void render(Canvas canvas, Size size, double zoom, Offset centerOffset) {
//     canvas.save();
//     canvas.translate(
//       size.width / 2 + (centerOffset.dx + position.dx * zoom),
//       size.height / 2 - (centerOffset.dy + position.dy * zoom),
//     );
//     canvas.scale(zoom);
//     _render(canvas);
//     canvas.restore();
//   }
// }

// class Character extends GameObject {
//   double rotation;

//   Character({
//     required super.size,
//     required super.position,
//     required this.rotation,
//   });

//   @override
//   void _render(Canvas canvas) {
//     // render arrow as placeholder
//     final paint = Paint()..color = Colors.blue;

//     canvas.rotate(rotation);
//     final path = Path();
//     path.moveTo(0, -this.size / 2);
//     path.lineTo(this.size / 2, this.size / 2);
//     path.lineTo(-this.size / 2, this.size / 2);
//     path.close();
//     canvas.drawPath(path, paint);
//   }
// }

// class Block extends GameObject {
//   Block({required super.size, required super.position});

//   @override
//   void _render(Canvas canvas) {
//     final paint =
//         Paint()
//           ..color = Colors.brown
//           ..style = PaintingStyle.fill
//           ;
//     final rect = Rect.fromCenter(
//       center: Offset(0, 0),
//       width: this.size + 1,
//       height: this.size + 1,
//     );
//     canvas.drawRect(rect, paint);
//   }
// }

// class GameObjectCubit extends Cubit<List<GameObject>> {
//   GameObjectCubit(super.initialState);

//   void updateObject(GameObject oldObject, GameObject newObject) {
//     final updatedList = List<GameObject>.from(state);
//     final index = updatedList.indexOf(oldObject);
//     if (index != -1) {
//       updatedList[index] = newObject;
//       emit(updatedList);
//     }
//   }

//   void addObject(GameObject object) {
//     final updatedList = List<GameObject>.from(state)..add(object);
//     emit(updatedList);
//   }

//   void removeObject(GameObject object) {
//     final updatedList = List<GameObject>.from(state)..remove(object);
//     emit(updatedList);
//   }
// }
