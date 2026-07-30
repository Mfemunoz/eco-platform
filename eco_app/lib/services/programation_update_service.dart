import 'package:supabase_flutter/supabase_flutter.dart';

class ProgramationUpdateService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<bool> startProgramation(int programationId, int vehicleId) async {
    try {
      print('Actualizando programación ID: $programationId');

      final programationResponse = await supabase
          .from('vehicle_programations')
          .update({'estado': 'En ruta'})
          .eq('id', programationId)
          .select();

      print('PROGRAMACION ACTUALIZADA: $programationResponse');

      print('Actualizando vehículo ID: $vehicleId');

      final vehicleResponse = await supabase
          .from('vehicles')
          .update({'estado': 'En ruta'})
          .eq('id', vehicleId)
          .select();

      print('VEHICULO ACTUALIZADO: $vehicleResponse');

      return true;
    } catch (e) {
      print('ERROR UPDATE OPERACION: $e');

      return false;
    }
  }
}
