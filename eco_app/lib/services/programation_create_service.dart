import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/create_programation_model.dart';
import '../models/vehicle_model.dart';

class ProgramationCreateService {
  final SupabaseClient supabase = Supabase.instance.client;

  // =====================================================
  // CONSULTAR VEHICULOS DISPONIBLES
  // Regla PO:
  // Solo vehículos en estado Disponible pueden asignarse
  // =====================================================

  Future<List<VehicleModel>> getAvailableVehicles() async {
    try {
      final response = await supabase
          .from('vehicles')
          .select()
          .eq('estado', 'Disponible');

      return response
          .map<VehicleModel>((item) => VehicleModel.fromMap(item))
          .toList();
    } catch (e) {
      print('Error cargando vehículos disponibles: $e');

      return [];
    }
  }

  // =====================================================
  // CREAR PROGRAMACION
  //
  // Flujo:
  //
  // 1. Validar vehículo disponible
  // 2. Crear programación
  // 3. Cambiar vehículo Disponible -> Asignado
  //
  // =====================================================

  Future<bool> createProgramation(CreateProgramationModel model) async {
    try {
      // -------------------------------------------------
      // PASO 1
      // Validar que el vehículo siga disponible
      // -------------------------------------------------

      final vehicleValidation = await supabase
          .from('vehicles')
          .select()
          .eq('id', model.vehicleId)
          .eq('estado', 'Disponible');

      if (vehicleValidation.isEmpty) {
        print('Vehículo no disponible para asignación');

        return false;
      }

      // -------------------------------------------------
      // PASO 2
      // Crear programación
      // -------------------------------------------------

      final programationResponse =
          await supabase.from('vehicle_programations').insert({
            'vehicle_id': model.vehicleId,

            'servicio': model.servicio,

            'origen': model.origen,

            'destino': model.destino,

            'fecha': model.fecha,

            'hora_programada': model.horaProgramada,

            'estado': 'Programado',
          }).select();

      print('PROGRAMACION CREADA: $programationResponse');

      // -------------------------------------------------
      // PASO 3
      // Cambiar vehículo a Asignado
      // -------------------------------------------------

      final vehicleResponse = await supabase
          .from('vehicles')
          .update({'estado': 'Asignado'})
          .eq('id', model.vehicleId)
          .select();

      print('VEHICULO ASIGNADO: $vehicleResponse');

      return true;
    } catch (e) {
      print('Error creando programación: $e');

      return false;
    }
  }
}
