class CreateProgramationModel {
  final String vehicleId;

  final String servicio;

  final String origen;

  final String destino;

  final String fecha;

  final String horaProgramada;

  CreateProgramationModel({
    required this.vehicleId,

    required this.servicio,

    required this.origen,

    required this.destino,

    required this.fecha,

    required this.horaProgramada,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicle_id': vehicleId,

      'servicio': servicio,

      'origen': origen,

      'destino': destino,

      'fecha': fecha,

      'hora_programada': horaProgramada,

      'estado': 'Programado',
    };
  }
}
