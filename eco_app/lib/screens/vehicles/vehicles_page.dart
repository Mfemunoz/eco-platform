import 'package:flutter/material.dart';

import '../../models/vehicle_model.dart';
import '../../services/vehicle_service.dart';

import 'vehicle_detail_page.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final VehicleService service = VehicleService();

  List<VehicleModel> vehicles = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadVehicles();
  }

  Future<void> loadVehicles() async {
    try {
      final data = await service.getVehicles();

      setState(() {
        vehicles = data;

        loading = false;
      });
    } catch (e) {
      print('Error pantalla vehículos: $e');

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehículos ECO')),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Padding(
                  padding: EdgeInsets.all(16),

                  child: Text(
                    'Control de flota y asignaciones',

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: vehicles.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay vehículos registrados',

                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: vehicles.length,

                          itemBuilder: (context, index) {
                            final vehicle = vehicles[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,

                                vertical: 8,
                              ),

                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(10),

                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),

                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: const Icon(
                                    Icons.local_shipping,

                                    color: Colors.green,
                                  ),
                                ),

                                title: Text(
                                  vehicle.placa,

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                subtitle: Text(
                                  '${vehicle.tipo}\n'
                                  '${vehicle.estado}',
                                ),

                                trailing: const Icon(
                                  Icons.arrow_forward_ios,

                                  size: 16,
                                ),

                                onTap: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                          VehicleDetailPage(vehicle: vehicle),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
