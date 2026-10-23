import 'package:digi_meh/core/data/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_builder/shimmer_builder.dart';

Widget defaultImageLoadingBuilder(
  BuildContext context,
  Widget child,
  ImageChunkEvent? loadingProgress,
) {
  if (loadingProgress == null) {
    return child;
  }

  return ShimmerPaintOver(child: SizedBox.fromSize(size: defaultImageSize));
}

Widget defaultImageFrameBuilder(
  BuildContext context,
  Widget child,
  int? frame,
  bool wasSynchronouslyLoaded,
) {
  if (wasSynchronouslyLoaded || frame != null) {
    return child;
  }

  return ShimmerPaintOver(child: SizedBox.fromSize(size: defaultImageSize));
}
