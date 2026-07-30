import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<int> getTotalContainers() async {
    final response = await _client.from('contenedores').select('id');

    return response.length;
  }

  Future<int> getInTransitContainers() async {
    final response = await _client
        .from('contenedores')
        .select('id')
        .eq('estado', 'En tránsito');

    return response.length;
  }

  Future<int> getInPortContainers() async {
    final response = await _client
        .from('contenedores')
        .select('id')
        .eq('estado', 'En puerto');

    return response.length;
  }

  Future<int> getFinishedContainers() async {
    final response = await _client
        .from('contenedores')
        .select('id')
        .eq('estado', 'Finalizado');

    return response.length;
  }
}
