import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vehicle_model.dart';

class VehicleDetailService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<VehicleModel?> getVehicleById(int id) async {
    try {
      final response = await supabase
          .from('vehicles')
          .select()
          .eq('id', id)
          .single();

      return VehicleModel.fromMap(response);
    } catch (e) {
      print('Error buscando vehículo: $e');

      return null;
    }
  }

  Future<bool> finalizarOperacion(int programationId, int vehicleId) async {
    try {
      final programationResponse = await supabase
          .from('vehicle_programations')
          .update({'estado': 'Finalizado'})
          .eq('id', programationId)
          .select();

      print('PROGRAMACION FINALIZADA: $programationResponse');

      final vehicleResponse = await supabase
          .from('vehicles')
          .update({'estado': 'Disponible'})
          .eq('id', vehicleId)
          .select();

      print('VEHICULO DISPONIBLE: $vehicleResponse');

      return true;
    } catch (e) {
      print('Error finalizando operación: $e');

      return false;
    }
  }
}
