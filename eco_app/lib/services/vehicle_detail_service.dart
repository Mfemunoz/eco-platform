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
}
