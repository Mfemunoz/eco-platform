import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vehicle_programation_model.dart';

class VehicleProgramationService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<VehicleProgramationModel>> getProgramations() async {
    try {
      final response = await supabase.from('vehicle_programations').select();

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

  Future<List<VehicleProgramationModel>> getProgramationsByVehicle(
    String vehicleId,
  ) async {
    try {
      final response = await supabase
          .from('vehicle_programations')
          .select()
          .eq('vehicle_id', vehicleId);

      print('==============================');

      print('PROGRAMACIONES VEHICULO');

      print(response);

      print('TOTAL: ${response.length}');

      print('==============================');

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
}
