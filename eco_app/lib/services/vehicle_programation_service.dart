import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vehicle_programation_model.dart';

class VehicleProgramationService {
  final SupabaseClient supabase = Supabase.instance.client;

  // =====================================
  // CONSULTAR PROGRAMACIONES
  // =====================================

  Future<List<VehicleProgramationModel>> getProgramations() async {
    try {
      final response = await supabase
          .from('vehicle_programations')
          .select()
          .order('created_at', ascending: false);

      print('==============================');
      print('PROGRAMACIONES SUPABASE');
      print(response);
      print('TOTAL PROGRAMACIONES: ${response.length}');
      print('==============================');

      return response
          .map<VehicleProgramationModel>(
            (item) => VehicleProgramationModel.fromMap(item),
          )
          .toList();
    } catch (e) {
      print('ERROR CARGANDO PROGRAMACIONES');
      print(e);

      return [];
    }
  }

  // =====================================
  // PROGRAMACIONES POR VEHICULO
  // =====================================

  Future<List<VehicleProgramationModel>> getProgramationsByVehicle(
    String vehicleId,
  ) async {
    try {
      final response = await supabase
          .from('vehicle_programations')
          .select()
          .eq('vehicle_id', vehicleId);

      return response
          .map<VehicleProgramationModel>(
            (item) => VehicleProgramationModel.fromMap(item),
          )
          .toList();
    } catch (e) {
      print('ERROR PROGRAMACIONES VEHICULO');
      print(e);

      return [];
    }
  }

  // =====================================
  // CREAR NUEVA PROGRAMACION ECO
  //
  // Flujo:
  //
  // 1. Crear programación
  // 2. Crear evento inicial
  // 3. Cambiar vehículo Disponible -> Asignado
  //
  // =====================================

  Future<bool> createProgramation({
    required int vehicleId,

    required String servicio,

    required String fecha,

    required String horaProgramada,

    required String origen,

    required String destino,
  }) async {
    try {
      print('==============================');
      print('CREANDO PROGRAMACION ECO');
      print('VEHICULO: $vehicleId');
      print('SERVICIO: $servicio');
      print('==============================');

      // =================================
      // PASO 1
      // Crear programación
      // =================================

      final programationResponse = await supabase
          .from('vehicle_programations')
          .insert({
            'vehicle_id': vehicleId,

            'servicio': servicio,

            'fecha': fecha,

            'hora_programada': horaProgramada,

            'origen': origen,

            'destino': destino,

            'estado': 'Programado',
          })
          .select()
          .single();

      print('==============================');
      print('PROGRAMACION CREADA');
      print(programationResponse);
      print('==============================');

      final int programationId = programationResponse['id'];

      // =================================
      // PASO 2
      // Crear evento inicial
      // =================================

      final eventResponse = await supabase.from('movement_events').insert({
        'programation_id': programationId,

        'evento': 'Programación creada',

        'observacion': servicio,

        'usuario': 'Sistema',
      }).select();

      print('==============================');
      print('EVENTO CREADO');
      print(eventResponse);
      print('==============================');

      // =================================
      // PASO 3
      // Actualizar vehículo
      // =================================

      final vehicleResponse = await supabase
          .from('vehicles')
          .update({'estado': 'Asignado'})
          .eq('id', vehicleId)
          .select();

      print('==============================');
      print('VEHICULO ACTUALIZADO');
      print(vehicleResponse);
      print('==============================');

      print('MOVIMIENTO ECO CREADO CORRECTAMENTE');

      return true;
    } catch (e) {
      print('==============================');
      print('ERROR CREANDO PROGRAMACION ECO');
      print(e);
      print('==============================');

      return false;
    }
  }
}
