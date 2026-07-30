import 'package:flutter/material.dart';

import '../../models/container_model.dart';
import '../../services/containers_service.dart';
import 'container_detail_page.dart';

class ContainersPage extends StatefulWidget {
  const ContainersPage({super.key});

  @override
  State<ContainersPage> createState() => _ContainersPageState();
}

class _ContainersPageState extends State<ContainersPage> {
  final ContainersService _service = ContainersService();

  late Future<List<ContainerModel>> _containers;

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

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<ContainerModel>>(
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

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),

                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  ContainerDetailPage(container: container),
                            ),
                          );
                        },

                        child: Card(
                          elevation: 2,

                          margin: const EdgeInsets.only(bottom: 12),

                          child: Padding(
                            padding: const EdgeInsets.all(12),

                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),

                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),

                                    borderRadius: BorderRadius.circular(8),
                                  ),

                                  child: const Icon(
                                    Icons.inventory_2,

                                    color: Colors.green,
                                  ),
                                ),

                                const SizedBox(width: 15),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        container.numeroContenedor,

                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,

                                          fontSize: 16,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text('Naviera: ${container.naviera}'),

                                      Text(
                                        '${container.origen} → ${container.destino}',
                                      ),

                                      Text('Estado: ${container.estado}'),

                                      Text(
                                        'Ubicación: ${container.ubicacionActual}',
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.arrow_forward_ios,

                                  size: 16,

                                  color: Colors.grey,
                                ),
                              ],
                            ),
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
