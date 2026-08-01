import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/movement_event_model.dart';

class MovementEventService {
  final SupabaseClient supabase = Supabase.instance.client;

  // ==========================================
  // CONSULTAR EVENTOS DE UNA PROGRAMACIÓN
  // ==========================================

  Future<List<MovementEventModel>> getEventsByProgramation(
    int programationId,
  ) async {
    try {
      final response = await supabase
          .from('movement_events')
          .select()
          .eq('programation_id', programationId)
          .order('fecha_hora', ascending: true);

      print('==============================');

      print('EVENTOS PROGRAMACION');

      print(response);

      print('TOTAL EVENTOS: ${response.length}');

      print('==============================');

      return response
          .map<MovementEventModel>((item) => MovementEventModel.fromMap(item))
          .toList();
    } catch (e) {
      print('==============================');

      print('ERROR CARGANDO EVENTOS');

      print(e);

      print('==============================');

      return [];
    }
  }

  // ==========================================
  // CREAR EVENTO OPERATIVO
  // ==========================================

  Future<bool> createEvent({
    required int programationId,

    required String evento,

    String? causal,

    String? observacion,

    String? usuario,
  }) async {
    try {
      final response = await supabase.from('movement_events').insert({
        'programation_id': programationId,

        'evento': evento,

        'causal': causal,

        'observacion': observacion,

        'usuario': usuario,

        'fecha_hora': DateTime.now().toIso8601String(),
      }).select();

      print('==============================');

      print('EVENTO CREADO');

      print(response);

      print('==============================');

      return true;
    } catch (e) {
      print('==============================');

      print('ERROR CREANDO EVENTO');

      print(e);

      print('==============================');

      return false;
    }
  }
}
