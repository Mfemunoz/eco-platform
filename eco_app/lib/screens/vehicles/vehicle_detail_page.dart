import 'package:flutter/material.dart';

import '../../models/vehicle_model.dart';
import '../../models/vehicle_assignment_model.dart';

import '../../services/vehicle_assignment_service.dart';

import '../../widgets/status_badge.dart';

class VehicleDetailPage extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetailPage({super.key, required this.vehicle});

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  final VehicleAssignmentService assignmentService = VehicleAssignmentService();

  List<VehicleAssignmentModel> assignments = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadAssignments();
  }

  Future<void> loadAssignments() async {
    final data = await assignmentService.getAssignmentsByVehicle(
      widget.vehicle.id,
    );

    setState(() {
      assignments = data;

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle Vehículo')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,

                          color: Colors.green,

                          size: 32,
                        ),

                        const SizedBox(width: 15),

                        Text(
                          widget.vehicle.placa,

                          style: const TextStyle(
                            fontSize: 24,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    _infoRow('Tipo', widget.vehicle.tipo),

                    _infoRow('Conductor', widget.vehicle.conductor),

                    _infoRow('Ubicación actual', widget.vehicle.ubicacion),

                    const SizedBox(height: 10),

                    const Text(
                      'Estado',

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    StatusBadge(estado: widget.vehicle.estado),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Información operativa',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            buildAssignments(),
          ],
        ),
      ),
    );
  }

  Widget buildAssignments() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (assignments.isEmpty) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.assignment, color: Colors.green),

          title: const Text('Asignaciones'),

          subtitle: const Text('Sin servicios activos'),
        ),
      );
    }

    return Column(
      children: assignments.map((item) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.assignment, color: Colors.green),

            title: Text(
              item.servicio,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Text(
              '${item.origen} → ${item.destino}\n'
              'Estado: ${item.estado}',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [
          SizedBox(
            width: 150,

            child: Text(
              label,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
