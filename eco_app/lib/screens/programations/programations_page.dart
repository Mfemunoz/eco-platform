import 'package:flutter/material.dart';

import '../../models/vehicle_programation_model.dart';

import '../../services/vehicle_programation_service.dart';

import 'programation_detail_page.dart';

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
                  elevation: 1,

                  margin: const EdgeInsets.only(bottom: 12),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,

                      vertical: 10,
                    ),

                    leading: Container(
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),

                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: const Icon(
                        Icons.calendar_month,

                        color: Colors.green,
                      ),
                    ),

                    title: Text(
                      item.servicio,

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),

                      child: Text(
                        '${item.origen} → ${item.destino}\n'
                        '${item.fecha} ${item.horaProgramada}\n'
                        'Estado: ${item.estado}',
                      ),
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              ProgramationDetailPage(programation: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
