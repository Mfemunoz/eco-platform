class VehicleProgramationModel {
  final String id;

  final String vehicleId;

  final String servicio;

  final String fecha;

  final String horaProgramada;

  final String origen;

  final String destino;

  final String estado;

  VehicleProgramationModel({
    required this.id,

    required this.vehicleId,

    required this.servicio,

    required this.fecha,

    required this.horaProgramada,

    required this.origen,

    required this.destino,

    required this.estado,
  });

  factory VehicleProgramationModel.fromMap(Map<String, dynamic> map) {
    return VehicleProgramationModel(
      id: map['id'].toString(),

      vehicleId: map['vehicle_id'].toString(),

      servicio: map['servicio'] ?? '',

      fecha: map['fecha'] ?? '',

      horaProgramada: map['hora_programada'] ?? '',

      origen: map['origen'] ?? '',

      destino: map['destino'] ?? '',

      estado: map['estado'] ?? '',
    );
  }
}
