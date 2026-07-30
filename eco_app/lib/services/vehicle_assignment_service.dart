import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vehicle_assignment_model.dart';

class VehicleAssignmentService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<VehicleAssignmentModel>> getAssignmentsByVehicle(
    String vehicleId,
  ) async {
    try {
      final response = await supabase
          .from('vehicle_assignments')
          .select()
          .eq('vehicle_id', vehicleId);

      print('==============================');

      print('ASIGNACIONES VEHICULO');

      print(response);

      print('TOTAL ASIGNACIONES: ${response.length}');

      print('==============================');

      return response
          .map<VehicleAssignmentModel>(
            (item) => VehicleAssignmentModel.fromMap(item),
          )
          .toList();
    } catch (e) {
      print('ERROR CARGANDO ASIGNACIONES');

      print(e);

      return [];
    }
  }
}
