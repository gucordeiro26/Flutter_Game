import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final IconData icon;
  final Color? color;

  const StatusBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = maxValue > 0 ? value / maxValue : 0.0;
    final displayColor = color ?? _getColorByPercentage(percentage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: displayColor, size: 16),
            const SizedBox(width: 4),
            Text(
              '$label: $value/$maxValue',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: displayColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorByPercentage(double percentage) {
    if (percentage > 0.7) return Colors.green;
    if (percentage > 0.3) return Colors.orange;
    return Colors.red;
  }
}