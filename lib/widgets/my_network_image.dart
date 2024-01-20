import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final BoxFit boxFit;

  MyNetworkImage({
    Key? key,
    required this.url,
    required this.height,
    required this.width,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      fadeInCurve: Curves.bounceIn,
      image: url,
      placeholder: "assets/images/loading.gif",
      placeholderFit: boxFit,
      height: height,
      width: width,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, object, stack) {
        return Image.asset(
          "assets/images/broken.png",
          fit: BoxFit.cover,
          height: height,
          width: width,
        );
      },
    );
  }
}
