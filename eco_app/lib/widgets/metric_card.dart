import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final IconData icon;

  final String value;

  final String label;

  const MetricCard({
    super.key,

    required this.icon,

    required this.value,

    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),

            blurRadius: 6,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: Colors.green),
          ),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                value,

                style: const TextStyle(
                  fontSize: 24,

                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                label,

                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
