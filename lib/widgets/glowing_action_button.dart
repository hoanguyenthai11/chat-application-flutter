import 'package:flutter/material.dart';

import '../theme.dart';

class GlowingActionButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  const GlowingActionButton(
      {super.key,
      required this.color,
      required this.icon,
      required this.onPressed,
      this.size = 54});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 24,
            offset: const Offset(-22, 0),
          ),
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 24,
            offset: const Offset(22, 0),
          ),
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 8,
            blurRadius: 42,
            offset: const Offset(-22, 0),
          ),
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 8,
            blurRadius: 42,
            offset: const Offset(22, 0),
          ),
        ],
      ),
      child: ClipOval(
        child: Material(
          color: color,
          child: InkWell(
            splashColor: AppColors.cardLight,
            onTap: onPressed,
            child: SizedBox(
                width: size,
                height: size,
                child: Icon(
                  icon,
                  size: 26,
                  color: Colors.white,
                )),
          ),
        ),
      ),
    );
  }
}
