import 'package:flutter/material.dart';

import '../../models/vehicle_programation_model.dart';
import '../../models/vehicle_model.dart';

import '../../services/vehicle_detail_service.dart';

import '../../widgets/status_badge.dart';

class ProgramationDetailPage extends StatefulWidget {
  final VehicleProgramationModel programation;

  const ProgramationDetailPage({super.key, required this.programation});

  @override
  State<ProgramationDetailPage> createState() => _ProgramationDetailPageState();
}

class _ProgramationDetailPageState extends State<ProgramationDetailPage> {
  final VehicleDetailService vehicleService = VehicleDetailService();

  VehicleModel? vehicle;

  bool loadingVehicle = true;

  @override
  void initState() {
    super.initState();

    loadVehicle();
  }

  Future<void> loadVehicle() async {
    final data = await vehicleService.getVehicleById(
      widget.programation.vehicleId,
    );

    setState(() {
      vehicle = data;

      loadingVehicle = false;
    });
  }

  Future<void> finalizarOperacion() async {
    final result = await vehicleService.finalizarOperacion(
      widget.programation.id,

      widget.programation.vehicleId,
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operación finalizada correctamente')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final programation = widget.programation;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle Programación')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),

                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.calendar_month,

                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Text(
                          programation.servicio,

                          style: const TextStyle(
                            fontSize: 24,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    _infoRow('Origen', programation.origen),

                    _infoRow('Destino', programation.destino),

                    _infoRow('Fecha', programation.fecha),

                    _infoRow('Hora', programation.horaProgramada),

                    const SizedBox(height: 12),

                    const Text(
                      'Estado',

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    StatusBadge(estado: programation.estado),
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

            Card(
              child: loadingVehicle
                  ? const Padding(
                      padding: EdgeInsets.all(20),

                      child: CircularProgressIndicator(),
                    )
                  : vehicle == null
                  ? const ListTile(title: Text('Vehículo no encontrado'))
                  : ListTile(
                      leading: const Icon(
                        Icons.local_shipping,

                        color: Colors.green,
                      ),

                      title: Text(
                        vehicle!.placa,

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(
                        '${vehicle!.tipo}\n'
                        'Conductor: ${vehicle!.conductor}\n'
                        'Ubicación: ${vehicle!.ubicacion}',
                      ),

                      trailing: StatusBadge(estado: vehicle!.estado),
                    ),
            ),

            const SizedBox(height: 20),

            if (programation.estado == 'En ruta')
              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),

                  label: const Text('Finalizar operación'),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,

                    foregroundColor: Colors.white,
                  ),

                  onPressed: finalizarOperacion,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [
          SizedBox(
            width: 120,

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
