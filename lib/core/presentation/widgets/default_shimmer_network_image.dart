import 'package:digi_meh/core/presentation/utils/default_image_loaders.dart';
import 'package:flutter/material.dart';

class DefaultShimmerNetworkImage extends StatelessWidget {
  const DefaultShimmerNetworkImage({super.key, required this.uriString});

  final String uriString;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      uriString,
      frameBuilder: defaultImageFrameBuilder,
      loadingBuilder: defaultImageLoadingBuilder,
      errorBuilder: defaultImageErrorBuilder,
    );
  }
}
