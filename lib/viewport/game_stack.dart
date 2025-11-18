// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_factory/character/character.dart';
// import 'package:flutter_factory/state/game_state.dart';
// import 'package:provider/provider.dart';

// // class GameStack extends StatefulWidget {
// //   const GameStack({super.key});

// //   @override
// //   State<GameStack> createState() => _GameStackState();
// // }

// // class _GameStackState extends State<GameStack> {

// //   List<Widget> gameObjects(GameState state) {
// //     final size = MediaQuery.of(context).size;
// //     final objects = <Widget>[];
// //     for (var x in state.objects.keys) {
// //       for (var y in state.objects[x]!.keys) {
// //         if (state.objects[x]![y] != null) {
// //           Widget? obj = state.buildObject(x, y, size);
// //           if (obj != null) {
// //             objects.add(obj);
// //           }
// //         }
// //       }
// //     }
// //     return objects;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Provider<GameStateBloc>(
// //       create: (_) => GameStateBloc(),
// //       builder: (context, child) {
// //         GameState state = context.watch<GameStateBloc>().state;
// //         final size = MediaQuery.of(context).size;
// //         return Stack(
// //           children: gameObjects(state),
// //           //   );
// //           // },
// //         );
// //       },
// //       // child: Container(
// //       //   // child: BlocBuilder<GameStateBloc, GameState>(
// //       //   //   builder: (context, state) {
// //       //       GameState state = context.watch<GameStateBloc>().state;
// //       //       return Stack(
// //       //         children: [
// //       //           for (var x in state.objects.keys)
// //       //             for (var y in state.objects[x]!.keys)
// //       //               state.buildObject(x, y),
// //       //         ],
// //       //     //   );
// //       //     // },
// //       //   ),
// //       // ),
// //     );
// //   }
// // }

// class GameStack extends MultiChildRenderObjectWidget {
//   /// Creates a stack layout widget.
//   ///
//   /// By default, the non-positioned children of the stack are aligned by their
//   /// top left corners.
//   const GameStack({
//     super.key,
//     this.alignment = Alignment.center,
//     this.textDirection,
//     this.fit = StackFit.loose,
//     this.clipBehavior = Clip.hardEdge,
//     this.centerOffset = Offset.zero,
//     super.children,
//   });

//   final Offset centerOffset;

//   /// How to align the non-positioned and partially-positioned children in the
//   /// stack.
//   ///
//   /// The non-positioned children are placed relative to each other such that
//   /// the points determined by [alignment] are co-located. For example, if the
//   /// [alignment] is [Alignment.topLeft], then the top left corner of
//   /// each non-positioned child will be located at the same global coordinate.
//   ///
//   /// Partially-positioned children, those that do not specify an alignment in a
//   /// particular axis (e.g. that have neither `top` nor `bottom` set), use the
//   /// alignment to determine how they should be positioned in that
//   /// under-specified axis.
//   ///
//   /// Defaults to [AlignmentDirectional.topStart].
//   ///
//   /// See also:
//   ///
//   ///  * [Alignment], a class with convenient constants typically used to
//   ///    specify an [AlignmentGeometry].
//   ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
//   ///    relative to text direction.
//   final AlignmentGeometry alignment;

//   /// The text direction with which to resolve [alignment].
//   ///
//   /// Defaults to the ambient [Directionality].
//   final TextDirection? textDirection;

//   /// How to size the non-positioned children in the stack.
//   ///
//   /// The constraints passed into the [GameStack] from its parent are either
//   /// loosened ([StackFit.loose]) or tightened to their biggest size
//   /// ([StackFit.expand]).
//   final StackFit fit;

//   /// {@macro flutter.material.Material.clipBehavior}
//   ///
//   /// Stacks only clip children whose _geometry_ overflows the stack. A child
//   /// that paints outside its bounds (e.g. a box with a shadow) will not be
//   /// clipped, regardless of the value of this property. Similarly, a child that
//   /// itself has a descendant that overflows the stack will not be clipped, as
//   /// only the geometry of the stack's direct children are considered.
//   /// [Transform] is an example of a widget that can cause its children to paint
//   /// outside its geometry.
//   ///
//   /// To clip children whose geometry does not overflow the stack, consider
//   /// using a [ClipRect] widget.
//   ///
//   /// Defaults to [Clip.hardEdge].
//   final Clip clipBehavior;

//   bool _debugCheckHasDirectionality(BuildContext context) {
//     if (alignment is AlignmentDirectional && textDirection == null) {
//       assert(
//         debugCheckHasDirectionality(
//           context,
//           why: "to resolve the 'alignment' argument",
//           hint:
//               alignment == AlignmentDirectional.topStart
//                   ? "The default value for 'alignment' is AlignmentDirectional.topStart, which requires a text direction."
//                   : null,
//           alternative:
//               "Instead of providing a Directionality widget, another solution would be passing a non-directional 'alignment', or an explicit 'textDirection', to the $runtimeType.",
//         ),
//       );
//     }
//     return true;
//   }

//   @override
//   GameRenderStack createRenderObject(BuildContext context) {
//     assert(_debugCheckHasDirectionality(context));
//     return GameRenderStack(
//       alignment: alignment,
//       textDirection: textDirection ?? Directionality.maybeOf(context),
//       fit: fit,
//       clipBehavior: clipBehavior,
//       centerOffset: centerOffset,
//     );
//   }

//   @override
//   void updateRenderObject(BuildContext context, GameRenderStack renderObject) {
//     assert(_debugCheckHasDirectionality(context));
//     renderObject
//       ..alignment = alignment
//       ..textDirection = textDirection ?? Directionality.maybeOf(context)
//       ..fit = fit
//       ..clipBehavior = clipBehavior
//       ..centerOffset = centerOffset;
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(
//       DiagnosticsProperty<AlignmentGeometry>('alignment', alignment),
//     );
//     properties.add(
//       EnumProperty<TextDirection>(
//         'textDirection',
//         textDirection,
//         defaultValue: null,
//       ),
//     );
//     properties.add(EnumProperty<StackFit>('fit', fit));
//     properties.add(
//       EnumProperty<Clip>(
//         'clipBehavior',
//         clipBehavior,
//         defaultValue: Clip.hardEdge,
//       ),
//     );
//   }
// }

// /// Implements the stack layout algorithm.
// ///
// /// In a stack layout, the children are positioned on top of each other in the
// /// order in which they appear in the child list. First, the non-positioned
// /// children (those with null values for top, right, bottom, and left) are
// /// laid out and initially placed in the upper-left corner of the stack. The
// /// stack is then sized to enclose all of the non-positioned children. If there
// /// are no non-positioned children, the stack becomes as large as possible.
// ///
// /// The final location of non-positioned children is determined by the alignment
// /// parameter. The left of each non-positioned child becomes the
// /// difference between the child's width and the stack's width scaled by
// /// alignment.x. The top of each non-positioned child is computed
// /// similarly and scaled by alignment.y. So if the alignment x and y properties
// /// are 0.0 (the default) then the non-positioned children remain in the
// /// upper-left corner. If the alignment x and y properties are 0.5 then the
// /// non-positioned children are centered within the stack.
// ///
// /// Next, the positioned children are laid out. If a child has top and bottom
// /// values that are both non-null, the child is given a fixed height determined
// /// by subtracting the sum of the top and bottom values from the height of the stack.
// /// Similarly, if the child has right and left values that are both non-null,
// /// the child is given a fixed width derived from the stack's width.
// /// Otherwise, the child is given unbounded constraints in the non-fixed dimensions.
// ///
// /// Once the child is laid out, the stack positions the child
// /// according to the top, right, bottom, and left properties of their
// /// [StackParentData]. For example, if the bottom value is 10.0, the
// /// bottom edge of the child will be inset 10.0 pixels from the bottom
// /// edge of the stack. If the child extends beyond the bounds of the
// /// stack, the stack will clip the child's painting to the bounds of
// /// the stack.
// ///
// /// See also:
// ///
// ///  * [RenderFlow]
// class GameRenderStack extends RenderBox
//     with
//         ContainerRenderObjectMixin<RenderBox, GameStackParentData>,
//         RenderBoxContainerDefaultsMixin<RenderBox, GameStackParentData> {
//   /// Creates a stack render object.
//   ///
//   /// By default, the non-positioned children of the stack are aligned by their
//   /// top left corners.
//   GameRenderStack({
//     List<RenderBox>? children,
//     AlignmentGeometry alignment = AlignmentDirectional.center,
//     TextDirection? textDirection,
//     StackFit fit = StackFit.loose,
//     Clip clipBehavior = Clip.hardEdge,
//     Offset centerOffset = Offset.zero,
//   }) : _alignment = alignment,
//        _textDirection = textDirection,
//        _fit = fit,
//        _clipBehavior = clipBehavior,
//        _centerOffset = centerOffset {
//     addAll(children);
//   }

//   bool _hasVisualOverflow = false;

//   @override
//   void setupParentData(RenderBox child) {
//     if (child.parentData is! GameStackParentData) {
//       child.parentData = GameStackParentData();
//     }
//   }

//   Alignment get _resolvedAlignment =>
//       _resolvedAlignmentCache ??= alignment.resolve(textDirection);
//   Alignment? _resolvedAlignmentCache;

//   void _markNeedResolution() {
//     _resolvedAlignmentCache = null;
//     markNeedsLayout();
//   }

//   Offset get centerOffset => _centerOffset;
//   Offset _centerOffset;
//   set centerOffset(Offset value) {
//     if (_centerOffset == value) {
//       return;
//     }
//     _centerOffset = value;
//     markNeedsLayout();
//   }

//   /// How to align the non-positioned or partially-positioned children in the
//   /// stack.
//   ///
//   /// The non-positioned children are placed relative to each other such that
//   /// the points determined by [alignment] are co-located. For example, if the
//   /// [alignment] is [Alignment.topLeft], then the top left corner of
//   /// each non-positioned child will be located at the same global coordinate.
//   ///
//   /// Partially-positioned children, those that do not specify an alignment in a
//   /// particular axis (e.g. that have neither `top` nor `bottom` set), use the
//   /// alignment to determine how they should be positioned in that
//   /// under-specified axis.
//   ///
//   /// If this is set to an [AlignmentDirectional] object, then [textDirection]
//   /// must not be null.
//   AlignmentGeometry get alignment => _alignment;
//   AlignmentGeometry _alignment;
//   set alignment(AlignmentGeometry value) {
//     if (_alignment == value) {
//       return;
//     }
//     _alignment = value;
//     _markNeedResolution();
//   }

//   /// The text direction with which to resolve [alignment].
//   ///
//   /// This may be changed to null, but only after the [alignment] has been changed
//   /// to a value that does not depend on the direction.
//   TextDirection? get textDirection => _textDirection;
//   TextDirection? _textDirection;
//   set textDirection(TextDirection? value) {
//     if (_textDirection == value) {
//       return;
//     }
//     _textDirection = value;
//     _markNeedResolution();
//   }

//   /// How to size the non-positioned children in the stack.
//   ///
//   /// The constraints passed into the [GameRenderStack] from its parent are either
//   /// loosened ([StackFit.loose]) or tightened to their biggest size
//   /// ([StackFit.expand]).
//   StackFit get fit => _fit;
//   StackFit _fit;
//   set fit(StackFit value) {
//     if (_fit != value) {
//       _fit = value;
//       markNeedsLayout();
//     }
//   }

//   /// {@macro flutter.material.Material.clipBehavior}
//   ///
//   /// Stacks only clip children whose geometry overflow the stack. A child that
//   /// paints outside its bounds (e.g. a box with a shadow) will not be clipped,
//   /// regardless of the value of this property. Similarly, a child that itself
//   /// has a descendant that overflows the stack will not be clipped, as only the
//   /// geometry of the stack's direct children are considered.
//   ///
//   /// To clip children whose geometry does not overflow the stack, consider
//   /// using a [RenderClipRect] render object.
//   ///
//   /// Defaults to [Clip.hardEdge].
//   Clip get clipBehavior => _clipBehavior;
//   Clip _clipBehavior = Clip.hardEdge;
//   set clipBehavior(Clip value) {
//     if (value != _clipBehavior) {
//       _clipBehavior = value;
//       markNeedsPaint();
//       markNeedsSemanticsUpdate();
//     }
//   }

//   /// Helper function for calculating the intrinsics metrics of a Stack.
//   static double getIntrinsicDimension(
//     RenderBox? firstChild,
//     double Function(RenderBox child) mainChildSizeGetter,
//   ) {
//     double extent = 0.0;
//     RenderBox? child = firstChild;
//     while (child != null) {
//       final GameStackParentData childParentData =
//           child.parentData! as GameStackParentData;
//       if (!childParentData.isPositioned) {
//         extent = math.max(extent, mainChildSizeGetter(child));
//       }
//       assert(child.parentData == childParentData);
//       child = childParentData.nextSibling;
//     }
//     return extent;
//   }

//   @override
//   double computeMinIntrinsicWidth(double height) {
//     return getIntrinsicDimension(
//       firstChild,
//       (RenderBox child) => child.getMinIntrinsicWidth(height),
//     );
//   }

//   @override
//   double computeMaxIntrinsicWidth(double height) {
//     return getIntrinsicDimension(
//       firstChild,
//       (RenderBox child) => child.getMaxIntrinsicWidth(height),
//     );
//   }

//   @override
//   double computeMinIntrinsicHeight(double width) {
//     return getIntrinsicDimension(
//       firstChild,
//       (RenderBox child) => child.getMinIntrinsicHeight(width),
//     );
//   }

//   @override
//   double computeMaxIntrinsicHeight(double width) {
//     return getIntrinsicDimension(
//       firstChild,
//       (RenderBox child) => child.getMaxIntrinsicHeight(width),
//     );
//   }

//   @override
//   double? computeDistanceToActualBaseline(TextBaseline baseline) {
//     return defaultComputeDistanceToHighestActualBaseline(baseline);
//   }

//   /// Lays out the positioned `child` according to `alignment` within a Stack of `size`.
//   ///
//   /// Returns true when the child has visual overflow.
//   static bool layoutPositionedChild(
//     RenderBox child,
//     GameStackParentData childParentData,
//     Size size,
//     Alignment alignment,
//   ) {
//     assert(childParentData.isPositioned);
//     assert(child.parentData == childParentData);
//     final BoxConstraints childConstraints = childParentData
//         .positionedChildConstraints(size);
//     child.layout(childConstraints, parentUsesSize: true);

//     final double x = switch (childParentData) {
//       GameStackParentData(:final double left?) =>
//         left +
//             (size.width / 2) -
//             (child.size.width / 2) -
//             childParentData.centerOffset.dx,
//       GameStackParentData(:final double right?) =>
//         size.width - right - child.size.width + childParentData.centerOffset.dx,
//       GameStackParentData() =>
//         alignment.alongOffset(size - child.size as Offset).dx,
//     };

//     final double y = switch (childParentData) {
//       GameStackParentData(:final double top?) =>
//         top +
//             (size.height / 2) -
//             (child.size.height / 2) -
//             childParentData.centerOffset.dy,
//       GameStackParentData(:final double bottom?) =>
//         (size.height / 2) -
//             bottom -
//             (child.size.height / 2) +
//             childParentData.centerOffset.dy,
//       GameStackParentData() =>
//         alignment.alongOffset(size - child.size as Offset).dy,
//     };

//     childParentData.offset = Offset(x, y);
//     return x < 0.0 ||
//         x + child.size.width > size.width ||
//         y < 0.0 ||
//         y + child.size.height > size.height;
//   }

//   static double? _baselineForChild(
//     RenderBox child,
//     Size stackSize,
//     BoxConstraints nonPositionedChildConstraints,
//     Alignment alignment,
//     TextBaseline baseline,
//   ) {
//     final GameStackParentData childParentData =
//         child.parentData! as GameStackParentData;
//     final BoxConstraints childConstraints =
//         childParentData.isPositioned
//             ? childParentData.positionedChildConstraints(stackSize)
//             : nonPositionedChildConstraints;
//     final double? baselineOffset = child.getDryBaseline(
//       childConstraints,
//       baseline,
//     );
//     if (baselineOffset == null) {
//       return null;
//     }
//     final double y = switch (childParentData) {
//       GameStackParentData(:final double top?) => top,
//       GameStackParentData(:final double bottom?) =>
//         stackSize.height - bottom - child.getDryLayout(childConstraints).height,
//       GameStackParentData() =>
//         alignment
//             .alongOffset(
//               stackSize - child.getDryLayout(childConstraints) as Offset,
//             )
//             .dy,
//     };
//     return baselineOffset + y;
//   }

//   @override
//   double? computeDryBaseline(
//     BoxConstraints constraints,
//     TextBaseline baseline,
//   ) {
//     final BoxConstraints nonPositionedChildConstraints = switch (fit) {
//       StackFit.loose => constraints.loosen(),
//       StackFit.expand => BoxConstraints.tight(constraints.biggest),
//       StackFit.passthrough => constraints,
//     };

//     final Alignment alignment = _resolvedAlignment;
//     final Size size = getDryLayout(constraints);

//     BaselineOffset baselineOffset = BaselineOffset.noBaseline;
//     for (
//       RenderBox? child = firstChild;
//       child != null;
//       child = childAfter(child)
//     ) {
//       baselineOffset = baselineOffset.minOf(
//         BaselineOffset(
//           _baselineForChild(
//             child,
//             size,
//             nonPositionedChildConstraints,
//             alignment,
//             baseline,
//           ),
//         ),
//       );
//     }
//     return baselineOffset.offset;
//   }

//   @override
//   @protected
//   Size computeDryLayout(covariant BoxConstraints constraints) {
//     return _computeSize(
//       constraints: constraints,
//       layoutChild: ChildLayoutHelper.dryLayoutChild,
//     );
//   }

//   Size _computeSize({
//     required BoxConstraints constraints,
//     required ChildLayouter layoutChild,
//   }) {
//     bool hasNonPositionedChildren = false;
//     if (childCount == 0) {
//       return constraints.biggest.isFinite
//           ? constraints.biggest
//           : constraints.smallest;
//     }

//     double width = constraints.minWidth;
//     double height = constraints.minHeight;

//     final BoxConstraints nonPositionedConstraints = switch (fit) {
//       StackFit.loose => constraints.loosen(),
//       StackFit.expand => BoxConstraints.tight(constraints.biggest),
//       StackFit.passthrough => constraints,
//     };

//     RenderBox? child = firstChild;
//     while (child != null) {
//       final GameStackParentData childParentData =
//           child.parentData! as GameStackParentData;

//       if (!childParentData.isPositioned) {
//         hasNonPositionedChildren = true;

//         final Size childSize = layoutChild(child, nonPositionedConstraints);

//         width = math.max(width, childSize.width);
//         height = math.max(height, childSize.height);
//       }

//       child = childParentData.nextSibling;
//     }

//     final Size size;
//     if (hasNonPositionedChildren) {
//       size = Size(width, height);
//       assert(size.width == constraints.constrainWidth(width));
//       assert(size.height == constraints.constrainHeight(height));
//     } else {
//       size = constraints.biggest;
//     }

//     assert(size.isFinite);
//     return size;
//   }

//   @override
//   void performLayout() {
//     final BoxConstraints constraints = this.constraints;
//     _hasVisualOverflow = false;

//     size = _computeSize(
//       constraints: constraints,
//       layoutChild: ChildLayoutHelper.layoutChild,
//     );

//     final Alignment resolvedAlignment = _resolvedAlignment;
//     RenderBox? child = firstChild;
//     while (child != null) {
//       final GameStackParentData childParentData =
//           child.parentData! as GameStackParentData;

//       if (!childParentData.isPositioned) {
//         childParentData.offset = resolvedAlignment.alongOffset(
//           size - child.size as Offset,
//         );
//       } else {
//         _hasVisualOverflow =
//             layoutPositionedChild(
//               child,
//               childParentData,
//               size,
//               resolvedAlignment,
//             ) ||
//             _hasVisualOverflow;
//       }

//       assert(child.parentData == childParentData);
//       child = childParentData.nextSibling;
//     }
//   }

//   @override
//   bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
//     return defaultHitTestChildren(result, position: position);
//   }

//   /// Override in subclasses to customize how the stack paints.
//   ///
//   /// By default, the stack uses [defaultPaint]. This function is called by
//   /// [paint] after potentially applying a clip to contain visual overflow.
//   @protected
//   void paintStack(PaintingContext context, Offset offset) {
//     defaultPaint(context, offset);
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     if (clipBehavior != Clip.none && _hasVisualOverflow) {
//       _clipRectLayer.layer = context.pushClipRect(
//         needsCompositing,
//         offset,
//         Offset.zero & size,
//         paintStack,
//         clipBehavior: clipBehavior,
//         oldLayer: _clipRectLayer.layer,
//       );
//     } else {
//       _clipRectLayer.layer = null;
//       paintStack(context, offset);
//     }
//   }

//   final LayerHandle<ClipRectLayer> _clipRectLayer =
//       LayerHandle<ClipRectLayer>();

//   @override
//   void dispose() {
//     _clipRectLayer.layer = null;
//     super.dispose();
//   }

//   @override
//   Rect? describeApproximatePaintClip(RenderObject child) {
//     switch (clipBehavior) {
//       case Clip.none:
//         return null;
//       case Clip.hardEdge:
//       case Clip.antiAlias:
//       case Clip.antiAliasWithSaveLayer:
//         return _hasVisualOverflow ? Offset.zero & size : null;
//     }
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(
//       DiagnosticsProperty<AlignmentGeometry>('alignment', alignment),
//     );
//     properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
//     properties.add(EnumProperty<StackFit>('fit', fit));
//     properties.add(
//       EnumProperty<Clip>(
//         'clipBehavior',
//         clipBehavior,
//         defaultValue: Clip.hardEdge,
//       ),
//     );
//   }
// }

// class GameStackParentData extends StackParentData {
//   Offset _centerOffset = Offset.zero;

//   Offset get centerOffset => _centerOffset;
//   set centerOffset(Offset value) {
//     if (_centerOffset == value) {
//       return;
//     }
//     _centerOffset = value;
//   }
// }

// class GamePos extends Positioned {
//   const GamePos({
//     super.key,
//     required super.child,
//     required double x,
//     required double y,
//     super.height,
//     super.width,
//   }) : super(left: x, bottom: y);
// }
