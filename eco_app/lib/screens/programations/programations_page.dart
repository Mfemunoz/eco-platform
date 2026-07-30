import 'package:flutter/material.dart';

import '../../models/vehicle_programation_model.dart';

import '../../services/vehicle_programation_service.dart';

class ProgramationsPage extends StatefulWidget {
  const ProgramationsPage({super.key});

  @override
  State<ProgramationsPage> createState() => _ProgramationsPageState();
}

class _ProgramationsPageState extends State<ProgramationsPage> {
  final VehicleProgramationService service = VehicleProgramationService();

  List<VehicleProgramationModel> programations = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadProgramations();
  }

  Future<void> loadProgramations() async {
    final data = await service.getProgramations();

    setState(() {
      programations = data;

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programaciones ECO')),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : programations.isEmpty
          ? const Center(child: Text('No hay programaciones'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: programations.length,

              itemBuilder: (context, index) {
                final item = programations[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.green),

                    title: Text(
                      item.servicio,

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      '${item.origen} → ${item.destino}\n'
                      '${item.fecha} ${item.horaProgramada}\n'
                      'Estado: ${item.estado}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
