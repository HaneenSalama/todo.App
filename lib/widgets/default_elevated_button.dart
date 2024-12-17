import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  final double height;
  final double width;
  final String label;
  final VoidCallback onPressed;
  const DefaultElevatedButton(
      {super.key,
      required this.height,
      required this.width,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}
