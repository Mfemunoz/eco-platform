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
    setState(() {
      loading = true;
    });

    final data = await service.getProgramations();

    setState(() {
      programations = data;

      loading = false;
    });
  }

  Future<void> refreshProgramations() async {
    await loadProgramations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programaciones ECO')),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : programations.isEmpty
          ? const Center(child: Text('No hay programaciones registradas'))
          : RefreshIndicator(
              onRefresh: refreshProgramations,

              child: ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: programations.length,

                itemBuilder: (context, index) {
                  final item = programations[index];

                  return Card(
                    elevation: 0,

                    margin: const EdgeInsets.only(bottom: 12),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,

                        vertical: 12,
                      ),

                      leading: Container(
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),

                          borderRadius: BorderRadius.circular(12),
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

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const SizedBox(height: 6),

                          Text('${item.origen} → ${item.destino}'),

                          Text('${item.fecha} ${item.horaProgramada}'),

                          Text('Estado: ${item.estado}'),
                        ],
                      ),

                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                      onTap: () async {
                        await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                ProgramationDetailPage(programation: item),
                          ),
                        );

                        // Recarga automática al volver

                        refreshProgramations();
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
