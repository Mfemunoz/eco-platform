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
    return SizedBox(
      height: 95,

      child: Card(
        elevation: 2,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

        child: Padding(
          padding: const EdgeInsets.all(14),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Container(
                width: 42,

                height: 42,

                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: Icon(icon, color: Colors.green, size: 22),
              ),

              const SizedBox(width: 14),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    value,

                    style: const TextStyle(
                      fontSize: 22,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    label,

                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
