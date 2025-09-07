import 'package:flutter/material.dart';

class MoreOption extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final VoidCallback? onTap;

  const MoreOption({
    super.key,
    this.icon,
    this.iconWidget,
    required this.label,
    this.onTap,
  }) : assert(
         icon != null || iconWidget != null,
         'Provide either icon or iconWidget',
       );

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyLarge?.color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade500, width: 1.6),
            ),
            child: iconWidget ?? Icon(icon, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
