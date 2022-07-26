import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const AnimatedProgressBar({
    Key? key,
    required this.value,
    required this.height,
  }) : super(key: key);

  double _floor(double value, [min = 0.0]) => value <= min ? min : value;
  Color _color(double value) {
    final rgb = (value * 255).toInt();
    return Colors.deepOrange.withGreen(rgb).withRed(255 - rgb);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        return Container(
          padding: const EdgeInsets.all(10),
          width: box.maxWidth,
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(height)),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: box.maxWidth * _floor(value),
                decoration: BoxDecoration(
                  color: _color(value),
                  borderRadius: BorderRadius.all(Radius.circular(height)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
