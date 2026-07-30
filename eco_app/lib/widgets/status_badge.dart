import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String estado;

  const StatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    Color color;

    Color background;

    IconData icon;

    switch (estado.toLowerCase()) {
      case 'disponible':
        color = Colors.green;

        background = Colors.green.withOpacity(0.15);

        icon = Icons.check_circle;

        break;

      case 'en ruta':
        color = Colors.orange;

        background = Colors.orange.withOpacity(0.15);

        icon = Icons.local_shipping;

        break;

      case 'mantenimiento':
        color = Colors.red;

        background = Colors.red.withOpacity(0.15);

        icon = Icons.build;

        break;

      case 'en tránsito':
      case 'en transito':
        color = Colors.blue;

        background = Colors.blue.withOpacity(0.15);

        icon = Icons.directions_boat;

        break;

      case 'en puerto':
        color = Colors.orange;

        background = Colors.orange.withOpacity(0.15);

        icon = Icons.anchor;

        break;

      default:
        color = Colors.grey;

        background = Colors.grey.withOpacity(0.15);

        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: background,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 16, color: color),

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
