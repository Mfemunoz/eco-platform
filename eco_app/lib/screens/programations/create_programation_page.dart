import 'package:flutter/material.dart';

import '../../models/vehicle_model.dart';

import '../../services/vehicle_programation_service.dart';
import '../../services/vehicle_service.dart';

class CreateProgramationPage extends StatefulWidget {
  const CreateProgramationPage({super.key});

  @override
  State<CreateProgramationPage> createState() => _CreateProgramationPageState();
}

class _CreateProgramationPageState extends State<CreateProgramationPage> {
  final VehicleProgramationService service = VehicleProgramationService();

  final VehicleService vehicleService = VehicleService();

  final TextEditingController servicioController = TextEditingController();

  final TextEditingController origenController = TextEditingController();

  final TextEditingController destinoController = TextEditingController();

  DateTime? fechaSeleccionada;

  TimeOfDay? horaSeleccionada;

  VehicleModel? selectedVehicle;

  List<VehicleModel> vehicles = [];

  bool loading = true;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    loadVehicles();
  }

  Future<void> loadVehicles() async {
    final data = await vehicleService.getAvailableVehicles();

    setState(() {
      vehicles = data;

      loading = false;
    });
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,

      firstDate: DateTime.now(),

      lastDate: DateTime.now().add(const Duration(days: 365)),

      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        fechaSeleccionada = date;
      });
    }
  }

  Future<void> selectTime() async {
    final time = await showTimePicker(
      context: context,

      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        horaSeleccionada = time;
      });
    }
  }

  Future<void> save() async {
    if (servicioController.text.isEmpty ||
        origenController.text.isEmpty ||
        destinoController.text.isEmpty ||
        fechaSeleccionada == null ||
        horaSeleccionada == null ||
        selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );

      return;
    }

    setState(() {
      saving = true;
    });

    final result = await service.createProgramation(
      vehicleId: int.parse(selectedVehicle!.id),

      servicio: servicioController.text.trim(),

      fecha: fechaSeleccionada!.toIso8601String().substring(0, 10),

      horaProgramada: horaSeleccionada!.format(context),

      origen: origenController.text.trim(),

      destino: destinoController.text.trim(),
    );

    setState(() {
      saving = false;
    });

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Programación creada correctamente")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error creando programación")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Programación")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  _card(
                    "Datos del movimiento",

                    Icons.calendar_month,

                    Column(
                      children: [
                        _input(
                          servicioController,

                          "Servicio",

                          Icons.assignment,
                        ),

                        _input(origenController, "Origen", Icons.location_on),

                        _input(destinoController, "Destino", Icons.flag),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    "Asignación vehículo",

                    Icons.local_shipping,

                    DropdownButtonFormField<VehicleModel>(
                      value: selectedVehicle,

                      decoration: const InputDecoration(
                        labelText: "Vehículo disponible",

                        border: OutlineInputBorder(),
                      ),

                      items: vehicles
                          .map(
                            (v) => DropdownMenuItem<VehicleModel>(
                              value: v,

                              child: Text("${v.placa} - ${v.tipo}"),
                            ),
                          )
                          .toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedVehicle = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    "Programación",

                    Icons.schedule,

                    Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today),

                          title: Text(
                            fechaSeleccionada == null
                                ? "Seleccionar fecha"
                                : "${fechaSeleccionada!.year}-${fechaSeleccionada!.month}-${fechaSeleccionada!.day}",
                          ),

                          onTap: selectDate,
                        ),

                        ListTile(
                          leading: const Icon(Icons.access_time),

                          title: Text(
                            horaSeleccionada == null
                                ? "Seleccionar hora"
                                : horaSeleccionada!.format(context),
                          ),

                          onTap: selectTime,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: saving ? null : save,

                      child: saving
                          ? const CircularProgressIndicator()
                          : const Text("CREAR MOVIMIENTO"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _input(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: TextField(
        controller: controller,

        decoration: InputDecoration(
          labelText: label,

          prefixIcon: Icon(icon),

          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _card(String title, IconData icon, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green),

                const SizedBox(width: 10),

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            child,
          ],
        ),
      ),
    );
  }
}
