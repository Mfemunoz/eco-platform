class MovementEventModel {
  final int id;

  final int programationId;

  final String evento;

  final String fechaHora;

  final String? causal;

  final String? observacion;

  final String? usuario;

  final String createdAt;

  MovementEventModel({
    required this.id,

    required this.programationId,

    required this.evento,

    required this.fechaHora,

    this.causal,

    this.observacion,

    this.usuario,

    required this.createdAt,
  });

  factory MovementEventModel.fromMap(Map<String, dynamic> map) {
    return MovementEventModel(
      id: map['id'] ?? 0,

      programationId: map['programation_id'] ?? 0,

      evento: map['evento'] ?? '',

      fechaHora: map['fecha_hora'] ?? '',

      causal: map['causal'],

      observacion: map['observacion'],

      usuario: map['usuario'],

      createdAt: map['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'programation_id': programationId,

      'evento': evento,

      'fecha_hora': fechaHora,

      'causal': causal,

      'observacion': observacion,

      'usuario': usuario,
    };
  }
}
