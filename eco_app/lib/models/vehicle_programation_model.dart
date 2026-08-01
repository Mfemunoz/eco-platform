class VehicleProgramationModel {
  final int id;

  final int vehicleId;

  final String servicio;

  final String origen;

  final String destino;

  final String fecha;

  final String horaProgramada;

  final String estado;

  VehicleProgramationModel({
    required this.id,

    required this.vehicleId,

    required this.servicio,

    required this.origen,

    required this.destino,

    required this.fecha,

    required this.horaProgramada,

    required this.estado,
  });

  factory VehicleProgramationModel.fromMap(Map<String, dynamic> map) {
    return VehicleProgramationModel(
      id: int.parse(map['id'].toString()),

      vehicleId: int.parse(map['vehicle_id'].toString()),

      servicio: map['servicio'] ?? '',

      origen: map['origen'] ?? '',

      destino: map['destino'] ?? '',

      fecha: map['fecha'] ?? '',

      horaProgramada: map['hora_programada'] ?? '',

      estado: map['estado'] ?? '',
    );
  }
}
