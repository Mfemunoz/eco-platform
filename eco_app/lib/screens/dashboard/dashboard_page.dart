import 'package:flutter/material.dart';
import '../containers/containers_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard ECO')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Resumen Operativo',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: 4,

              crossAxisSpacing: 12,

              mainAxisSpacing: 12,

              childAspectRatio: 2.5,

              children: [
                _metricCard(Icons.inventory_2, '0', 'Contenedores'),

                _metricCard(Icons.local_shipping, '0', 'Operaciones'),

                _metricCard(Icons.route, '0', 'En Movimiento'),

                _metricCard(Icons.check_circle, '0', 'Finalizados'),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Módulos ECO',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _moduleCard(
              context,

              Icons.inventory_2,

              'Contenedores',

              'Gestión y seguimiento operativo',

              true,
            ),

            _moduleCard(
              context,

              Icons.local_shipping,

              'Vehículos',

              'Control de flota y asignaciones',

              false,
            ),

            _moduleCard(
              context,

              Icons.assignment,

              'Programaciones',

              'Planificación de operaciones',

              false,
            ),

            _moduleCard(
              context,

              Icons.bar_chart,

              'Reportes',

              'Indicadores y análisis',

              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(IconData icon, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: Colors.grey.shade200),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),

            blurRadius: 4,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, color: Colors.green, size: 25),

          const SizedBox(width: 12),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                value,

                style: const TextStyle(
                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _moduleCard(
    BuildContext context,

    IconData icon,

    String title,

    String subtitle,

    bool active,
  ) {
    return InkWell(
      onTap: active
          ? () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (_) => const ContainersPage()),
              );
            }
          : null,

      child: Container(
        margin: const EdgeInsets.only(bottom: 8),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: Colors.grey.shade200),
        ),

        child: Row(
          children: [
            Icon(icon, color: Colors.green),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 15,

                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text(
                    subtitle,

                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 15),
          ],
        ),
      ),
    );
  }
}
