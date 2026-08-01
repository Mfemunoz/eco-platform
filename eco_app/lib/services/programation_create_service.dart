import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/create_programation_model.dart';
import '../models/vehicle_model.dart';

class ProgramationCreateService {
  final SupabaseClient supabase = Supabase.instance.client;

  // =====================================================
  // CONSULTAR VEHICULOS DISPONIBLES
  //
  // Solo vehículos en estado Disponible pueden asignarse
  //
  // =====================================================

  Future<List<VehicleModel>> getAvailableVehicles() async {
    try {
      final response = await supabase
          .from('vehicles')
          .select()
          .eq('estado', 'Disponible');

      print('==============================');
      print('VEHICULOS DISPONIBLES');
      print(response);
      print('TOTAL DISPONIBLES: ${response.length}');
      print('==============================');

      return response
          .map<VehicleModel>((item) => VehicleModel.fromMap(item))
          .toList();
    } catch (e) {
      print('==============================');
      print('ERROR CARGANDO VEHICULOS DISPONIBLES');
      print(e);
      print('==============================');

      return [];
    }
  }

  // =====================================================
  // CREAR PROGRAMACION ECO
  //
  // Flujo:
  //
  // 1. Validar vehículo disponible
  // 2. Crear programación
  // 3. Crear evento inicial
  // 4. Cambiar vehículo a Asignado
  //
  // =====================================================

  Future<bool> createProgramation(CreateProgramationModel model) async {
    try {
      // =================================================
      // PASO 1
      // Validar vehículo disponible
      // =================================================

      final vehicleValidation = await supabase
          .from('vehicles')
          .select()
          .eq('id', model.vehicleId)
          .eq('estado', 'Disponible');

      print('==============================');
      print('VALIDACION VEHICULO');
      print(vehicleValidation);
      print('==============================');

      if (vehicleValidation.isEmpty) {
        print('VEHICULO NO DISPONIBLE');

        return false;
      }

      // =================================================
      // PASO 2
      // Crear programación
      // =================================================

      final programationResponse = await supabase
          .from('vehicle_programations')
          .insert({
            'vehicle_id': model.vehicleId,

            'servicio': model.servicio,

            'origen': model.origen,

            'destino': model.destino,

            'fecha': model.fecha,

            'hora_programada': model.horaProgramada,

            'estado': 'Programado',
          })
          .select()
          .single();

      print('==============================');
      print('PROGRAMACION CREADA');
      print(programationResponse);
      print('==============================');

      final int programationId = programationResponse['id'];

      print('ID PROGRAMACION: $programationId');

      // =================================================
      // PASO 3
      // Crear evento inicial
      // =================================================

      print('==============================');
      print('CREANDO EVENTO MOVIMIENTO');
      print('PROGRAMACION ID: $programationId');
      print('==============================');

      final eventResponse = await supabase
          .from('movement_events')
          .insert({
            'programation_id': programationId,

            'evento': 'Programación creada',

            'observacion': model.servicio,

            'usuario': 'Sistema',
          })
          .select()
          .single();

      print('==============================');
      print('EVENTO INSERTADO DESDE FLUTTER');
      print(eventResponse);
      print('==============================');

      // =================================================
      // PASO 4
      // Cambiar vehículo a Asignado
      // =================================================

      final vehicleResponse = await supabase
          .from('vehicles')
          .update({'estado': 'Asignado'})
          .eq('id', model.vehicleId)
          .select();

      print('==============================');
      print('VEHICULO ACTUALIZADO');
      print(vehicleResponse);
      print('==============================');

      print('==============================');
      print('MOVIMIENTO ECO CREADO CORRECTAMENTE');
      print('==============================');

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
