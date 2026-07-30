import 'package:flutter/material.dart';

import '../../services/dashboard_service.dart';
import '../../widgets/metric_card.dart';

import '../containers/containers_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService _service = DashboardService();

  int containers = 0;
  int operations = 0;
  int inMovement = 0;
  int finished = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadMetrics();
  }

  Future<void> loadMetrics() async {
    final total = await _service.getTotalContainers();

    final transit = await _service.getInTransitContainers();

    final complete = await _service.getFinishedContainers();

    setState(() {
      containers = total;

      operations = total;

      inMovement = transit;

      finished = complete;

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard ECO')),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    spacing: 16,

                    runSpacing: 16,

                    children: [
                      metric(
                        Icons.inventory_2,

                        containers.toString(),

                        'Contenedores',
                      ),

                      metric(
                        Icons.local_shipping,

                        operations.toString(),

                        'Operaciones',
                      ),

                      metric(
                        Icons.route,

                        inMovement.toString(),

                        'En Movimiento',
                      ),

                      metric(
                        Icons.check_circle,

                        finished.toString(),

                        'Finalizados',
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  const Text(
                    'Módulos ECO',

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  moduleCard(
                    context,

                    Icons.inventory_2,

                    'Contenedores',

                    'Gestión y seguimiento operativo',

                    const ContainersPage(),
                  ),

                  moduleCard(
                    context,

                    Icons.local_shipping,

                    'Vehículos',

                    'Control de flota y asignaciones',

                    null,
                  ),

                  moduleCard(
                    context,

                    Icons.assignment,

                    'Programaciones',

                    'Planificación de operaciones',

                    null,
                  ),

                  moduleCard(
                    context,

                    Icons.bar_chart,

                    'Reportes',

                    'Indicadores y análisis',

                    null,
                  ),
                ],
              ),
            ),
    );
  }

  Widget metric(IconData icon, String value, String label) {
    return SizedBox(
      width: 230,

      height: 110,

      child: MetricCard(icon: icon, value: value, label: label),
    );
  }

  Widget moduleCard(
    BuildContext context,

    IconData icon,

    String title,

    String subtitle,

    Widget? page,
  ) {
    return Card(
      elevation: 0,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

        leading: Icon(icon, color: Colors.green),

        title: Text(title),

        subtitle: Text(subtitle),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: page == null
            ? null
            : () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => page),
                );
              },
      ),
    );
  }
}
