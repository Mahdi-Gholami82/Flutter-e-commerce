import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShrikableCircle extends SingleChildRenderObjectWidget {
  const ShrikableCircle({
    super.key,
    required this.color,
    required this.inPaddingAll,
    required super.child,
  });
  final Color color;
  final double inPaddingAll;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderShrikableCirclePainter(color: color, inPaddingAll: inPaddingAll);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderShrikableCirclePainter renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject.color = color;
    renderObject.inPaddingAll = inPaddingAll;
  }
}

class RenderShrikableCirclePainter extends RenderProxyBox {
  Color color;
  double inPaddingAll;
  RenderShrikableCirclePainter({
    required this.color,
    required this.inPaddingAll,
  });

  @override
  void performLayout() {
    if (child == null) {
      size = computeSizeForNoChild(constraints);
      return;
    }
    size = constraints.constrain(
      (child!..layout(constraints.loosen(), parentUsesSize: true)).size,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()..color = color;
    context.canvas.drawCircle(
      size.center(Offset.zero),
      min(size.width, size.height) / 2 - inPaddingAll,
      paint,
    );
    super.paint(context, offset);
  }
}
