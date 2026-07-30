import 'package:flutter/material.dart';
import '../../core/widgets/metric_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard ECO')),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Resumen Operativo',

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 12,

                runSpacing: 12,

                children: const [
                  SizedBox(
                    width: 280,

                    height: 100,

                    child: MetricCard(
                      title: 'Contenedores',

                      value: '0',

                      icon: Icons.inventory_2,
                    ),
                  ),

                  SizedBox(
                    width: 280,

                    height: 100,

                    child: MetricCard(
                      title: 'Operaciones',

                      value: '0',

                      icon: Icons.local_shipping,
                    ),
                  ),

                  SizedBox(
                    width: 280,

                    height: 100,

                    child: MetricCard(
                      title: 'En Movimiento',

                      value: '0',

                      icon: Icons.route,
                    ),
                  ),

                  SizedBox(
                    width: 280,

                    height: 100,

                    child: MetricCard(
                      title: 'Finalizados',

                      value: '0',

                      icon: Icons.check_circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                'Módulos ECO',

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              _moduleCard(
                icon: Icons.inventory_2,

                title: 'Contenedores',

                subtitle: 'Gestión y seguimiento operativo',
              ),

              _moduleCard(
                icon: Icons.local_shipping,

                title: 'Vehículos',

                subtitle: 'Control de flota y asignaciones',
              ),

              _moduleCard(
                icon: Icons.assignment,

                title: 'Programaciones',

                subtitle: 'Planificación de operaciones',
              ),

              _moduleCard(
                icon: Icons.bar_chart,

                title: 'Reportes',

                subtitle: 'Indicadores y análisis',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moduleCard({
    required IconData icon,

    required String title,

    required String subtitle,
  }) {
    return Card(
      elevation: 1,

      margin: const EdgeInsets.only(bottom: 8),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),

        leading: Icon(icon, color: Colors.green),

        title: Text(title),

        subtitle: Text(subtitle),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
