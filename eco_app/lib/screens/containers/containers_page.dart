import 'package:flutter/material.dart';
import '../../services/containers_service.dart';

class ContainersPage extends StatefulWidget {
  const ContainersPage({super.key});

  @override
  State<ContainersPage> createState() => _ContainersPageState();
}

class _ContainersPageState extends State<ContainersPage> {
  final ContainersService _service = ContainersService();

  late Future<List<Map<String, dynamic>>> _containers;

  @override
  void initState() {
    super.initState();

    _containers = _service.getContainers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contenedores ECO')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Gestión y seguimiento operativo',

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _containers,

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final containers = snapshot.data ?? [];

                  if (containers.isEmpty) {
                    return const Center(
                      child: Text('No hay contenedores registrados'),
                    );
                  }

                  return ListView.builder(
                    itemCount: containers.length,

                    itemBuilder: (context, index) {
                      final container = containers[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),

                        child: ListTile(
                          leading: const Icon(
                            Icons.inventory_2,

                            color: Colors.green,
                          ),

                          title: Text(
                            container['numero_contenedor'] ?? 'Sin número',
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(container['naviera'] ?? ''),

                              Text(
                                '${container['origen']} → ${container['destino']}',
                              ),

                              Text('Estado: ${container['estado']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
