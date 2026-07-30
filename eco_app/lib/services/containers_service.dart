import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/container_model.dart';

class ContainersService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<ContainerModel>> getContainers() async {
    final response = await _client
        .from('contenedores')
        .select()
        .order('created_at', ascending: false);

    return response
        .map<ContainerModel>((item) => ContainerModel.fromJson(item))
        .toList();
  }
}
