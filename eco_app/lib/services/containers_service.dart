import 'package:supabase_flutter/supabase_flutter.dart';

class ContainersService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getContainers() async {
    final response = await _client
        .from('contenedores')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
