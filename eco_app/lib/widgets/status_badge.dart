import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String estado;

  const StatusBadge({super.key, required this.estado});

  Color getColor() {
    switch (estado.toLowerCase()) {
      case 'en tránsito':
        return Colors.green;

      case 'en puerto':
        return Colors.orange;

      case 'liberado':
        return Colors.blue;

      case 'incidencia':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  IconData getIcon() {
    switch (estado.toLowerCase()) {
      case 'en tránsito':
        return Icons.local_shipping;

      case 'en puerto':
        return Icons.anchor;

      case 'liberado':
        return Icons.check_circle;

      case 'incidencia':
        return Icons.warning;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.15),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(getIcon(), size: 16, color: color),

          const SizedBox(width: 6),

          Text(
            estado,

            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
