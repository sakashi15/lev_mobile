import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  Widget child;
  Background({Key? key, required this.child}) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Image.asset(
                "assets/images/bg_shape2.png",
                width: size.width * 0.3,
              ),
              top: 0,
              right: 0,
            ),
            Positioned(
              child: Image.asset(
                "assets/images/bg_shape1.png",
                width: size.width * 0.3,
              ),
              bottom: 0,
              left: 0,
            ),
            widget.child
          ],
        ),
    );
  }
}
