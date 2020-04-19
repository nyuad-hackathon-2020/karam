import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';

class QuickRoundedImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  const QuickRoundedImage({Key key, this.imagePath, this.fit = BoxFit.cover})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: fit,
          image: imagePath != null
              ? CacheImage(imagePath)
              : AssetImage('assets/food_plate.jpg'),
        ),
      ),
    );
  }
}
