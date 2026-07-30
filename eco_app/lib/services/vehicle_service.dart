import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vehicle_model.dart';

class VehicleService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<VehicleModel>> getVehicles() async {
    try {
      final response = await supabase.from('vehicles').select();

      // PRUEBA DE CONEXIÓN SUPABASE

      print('==============================');

      print('VEHICULOS SUPABASE:');

      print(response);

      print('TOTAL VEHICULOS: ${response.length}');

      print('==============================');

      final vehicles = response
          .map<VehicleModel>((item) => VehicleModel.fromMap(item))
          .toList();

      print('MODELOS CREADOS: ${vehicles.length}');

      return vehicles;
    } catch (e) {
      print('==============================');

      print('ERROR VEHICLE SERVICE');

      print(e);

      print('==============================');

      return [];
    }
  }
}
