import 'package:flutter/material.dart';

import '../../../models/container_model.dart';
import '../../../widgets/status_badge.dart';

class ContainerDetailPage extends StatelessWidget {
  final ContainerModel container;

  const ContainerDetailPage({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle Contenedor')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              elevation: 2,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),

                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons.inventory_2,

                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Text(
                          container.numeroContenedor,

                          style: const TextStyle(
                            fontSize: 22,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _item('Naviera', container.naviera),

                    _item('Ruta', '${container.origen} → ${container.destino}'),

                    const SizedBox(height: 10),

                    const Text(
                      'Estado',

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    StatusBadge(estado: container.estado),

                    const SizedBox(height: 12),

                    _item('Ubicación actual', container.ubicacionActual),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Seguimiento operativo',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _timelineItem('Registro creado', true),

            _timelineItem('Salida puerto origen', true),

            _timelineItem('En navegación', container.estado == 'En tránsito'),

            _timelineItem('Llegada destino', false),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [
          SizedBox(
            width: 130,

            child: Text(
              title,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _timelineItem(String text, bool completed) {
    return ListTile(
      leading: Icon(
        completed ? Icons.check_circle : Icons.radio_button_unchecked,

        color: completed ? Colors.green : Colors.grey,
      ),

      title: Text(text),
    );
  }
}
