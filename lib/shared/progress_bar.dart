import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const AnimatedProgressBar({
    Key? key,
    required this.value,
    this.height = 12,
  }) : super(key: key);

  double _constraint(double value, {min = 0.0, max = 1.0}) => value <= min
      ? min
      : value >= max
          ? max
          : value;
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
                width: box.maxWidth * _constraint(value),
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
