// import 'dart:math' as math;
// import 'dart:ui';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_factory/game/game_object.dart';

// class GameScrollView extends TwoDimensionalScrollView {
//   const GameScrollView({
//     super.key,
//     super.diagonalDragBehavior,
//     super.dragStartBehavior,
//     super.horizontalDetails,
//     super.verticalDetails,
//     required super.delegate,
//   });

//   @override
//   Widget buildViewport(
//     BuildContext context,
//     ViewportOffset verticalOffset,
//     ViewportOffset horizontalOffset,
//   ) {
//     return GameScrollViewPort(
//       verticalOffset: verticalOffset,
//       horizontalOffset: horizontalOffset,
//       verticalAxisDirection: AxisDirection.down,
//       horizontalAxisDirection: AxisDirection.right,
//       delegate: delegate,
//       mainAxis: Axis.vertical,
//     );
//   }
// }

// class TwoDimensionalScrollController {
//   final ScrollableDetails horizontalDetails;
//   final ScrollableDetails verticalDetails;
//   final ScrollController horizontalController;
//   final ScrollController verticalController;

//   TwoDimensionalScrollController({
//     required this.horizontalDetails,
//     required this.verticalDetails,
//   }) : horizontalController =
//            horizontalDetails.controller ?? ScrollController(),
//        verticalController = verticalDetails.controller ?? ScrollController();
// }

// class GameScrollViewPort extends TwoDimensionalViewport {
//   const GameScrollViewPort({
//     super.key,
//     required super.verticalOffset,
//     required super.verticalAxisDirection,
//     required super.horizontalOffset,
//     required super.horizontalAxisDirection,
//     required super.delegate,
//     required super.mainAxis,
//     super.cacheExtent,
//     super.clipBehavior = Clip.hardEdge,
//   });

//   @override
//   RenderGameScrollViewPort createRenderObject(BuildContext context) {
//     return RenderGameScrollViewPort(
//       horizontalOffset: horizontalOffset,
//       horizontalAxisDirection: horizontalAxisDirection,
//       verticalOffset: verticalOffset,
//       verticalAxisDirection: verticalAxisDirection,
//       mainAxis: mainAxis,
//       delegate: delegate,
//       childManager: context as TwoDimensionalChildManager,
//     );
//   }

//   @override
//   void updateRenderObject(
//     BuildContext context,
//     RenderGameScrollViewPort renderObject,
//   ) {
//     renderObject
//       ..horizontalOffset = horizontalOffset
//       ..horizontalAxisDirection = horizontalAxisDirection
//       ..verticalOffset = verticalOffset
//       ..verticalAxisDirection = verticalAxisDirection
//       ..mainAxis = mainAxis
//       ..delegate = delegate
//       ..cacheExtent = cacheExtent
//       ..clipBehavior = clipBehavior;
//   }
// }

// class RenderGameScrollViewPort extends RenderTwoDimensionalViewport {
//   RenderGameScrollViewPort({
//     required super.horizontalOffset,
//     required super.horizontalAxisDirection,
//     required super.verticalOffset,
//     required super.verticalAxisDirection,
//     required super.delegate,
//     required super.mainAxis,
//     required super.childManager,
//   });

//   @override
//   void layoutChildSequence() {
//     final double horizontalPixels = horizontalOffset.pixels;
//     final double verticalPixels = verticalOffset.pixels;
//     final double viewportWidth = viewportDimension.width + cacheExtent;
//     final double viewportHeight = viewportDimension.height + cacheExtent;
//     final GameChildDelegate builderDelegate =
//         delegate as GameChildDelegate;
//     final int max = builderDelegate.maxXIndex ?? 0;
//     // for (int row = 0; row <= max; row++) {
//     for (var element in GameChildDelegate.cachedTiles.entries) {          
//       // final SingleVicinity vicinity = SingleVicinity(zIndex: row);
//       final SingleVicinity vicinity = element.key;
//       final RenderBox child = buildOrObtainChildFor(vicinity)!;
//       child.layout(constraints.loosen(), parentUsesSize: true);
      
//       // Subclasses only need to set the normalized layout offset. The super
//       // class adjusts for reversed axes.
//       parentDataOf(child).layoutOffset = Offset(
//         (viewportDimension.width / 2) - child.size.width / 2,
//         (viewportDimension.height / 2) - child.size.height / 2,
//       );
//     }

//     // Set the min and max scroll extents for each axis.
//     // final double verticalExtent = 200 * (maxRowIndex + 1);
//     verticalOffset.applyContentDimensions(
//       -viewportHeight / 2,
//       viewportHeight / 2,
//     );
//     // final double horizontalExtent = 200 * (maxColumnIndex + 1);
//     horizontalOffset.applyContentDimensions(
//       -viewportWidth / 2,
//       viewportWidth / 2,
//     );
//     // Super class handles garbage collection too!
//   }
// }

// class GameChildDelegate extends TwoDimensionalChildBuilderDelegate {
//   static final Map<SingleVicinity, GameObject> cachedTiles = {};
//   // static final Map<int, List<Widget>> levels = {};


//   GameChildDelegate() :
//       super(builder: _builder, addAutomaticKeepAlives: true, addRepaintBoundaries: true);

//   static Widget? _builder(BuildContext context, ChildVicinity vicinity) {
//     return cachedTiles[vicinity]?.widgetBuilder(context);
//   }
// }

// class SingleVicinity extends ChildVicinity {
//   const SingleVicinity({required zIndex}) : super(xIndex: zIndex, yIndex: 0);

//   @override
//   int compareTo(ChildVicinity other) {
//     if (other is! SingleVicinity) {
//       throw ArgumentError(
//         'Cannot compare SingleVicinity with ${other.runtimeType}',
//       );
//     }
//     int result = xIndex.compareTo(other.xIndex);
//     if (result != 0) {
//       return result;
//     } else {
//       return 1;
//     }
//   }
// }

// class CustomScrollController extends ScrollController {
//   // final TwoDimensionalChildPositionDelegate delegate;
//   ScrollBehavior scrollBehavior = const MaterialScrollBehavior().copyWith(
//     // Mouse dragging enabled for this demo
//     dragDevices: {PointerDeviceKind.mouse},
//   );
//   CustomScrollController({
//     super.initialScrollOffset = 0.0,
//     super.keepScrollOffset = true,
//     super.debugLabel,
//     super.onAttach,
//     super.onDetach,
//     // required this.delegate,
//   }) : super();

//   @override
//   ScrollPosition createScrollPosition(
//     ScrollPhysics physics,
//     ScrollContext context,
//     ScrollPosition? oldPosition,
//   ) {
//     context.setCanDrag(false);
//     return CustomScrollPosition(
//       physics: physics,
//       context: context,
//       oldPosition: oldPosition,
//       // delegate: delegate,
//     );
//   }
// }

// class ImplicitScrollPhysics extends BouncingScrollPhysics {
//   const ImplicitScrollPhysics({super.parent});

//   @override
//   ImplicitScrollPhysics applyTo(ScrollPhysics? ancestor) {
//     return ImplicitScrollPhysics(parent: buildParent(ancestor));
//   }

//   @override
//   bool get allowUserScrolling => false;
// }

// class CustomScrollPosition extends ScrollPositionWithSingleContext {
//   // final TwoDimensionalChildPositionDelegate delegate;

//   CustomScrollPosition({
//     required super.physics,
//     required super.context,
//     super.oldPosition,
//     // required this.delegate
//   }) : super(initialPixels: 0.0, keepScrollOffset: true);

//   @override
//   void applyUserOffset(double delta) {
//     // if (!delegate.allowMouseDrag) {
//     //   return;
//     // }
//     super.applyUserOffset(delta);
//   }

//   @override
//   void pointerScroll(double delta) {
//     // if (!delegate.allowMouseScroll) {
//     //   return;
//     // }
//     super.pointerScroll(delta);
//   }
// }
