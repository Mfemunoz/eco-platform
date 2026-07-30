class VehicleAssignmentModel {
  final String id;

  final String vehicleId;

  final String servicio;

  final String origen;

  final String destino;

  final String fecha;

  final String estado;

  VehicleAssignmentModel({
    required this.id,

    required this.vehicleId,

    required this.servicio,

    required this.origen,

    required this.destino,

    required this.fecha,

    required this.estado,
  });

  factory VehicleAssignmentModel.fromMap(Map<String, dynamic> map) {
    return VehicleAssignmentModel(
      id: map['id'].toString(),

      vehicleId: map['vehicle_id'].toString(),

      servicio: map['servicio'] ?? '',

      origen: map['origen'] ?? '',

      destino: map['destino'] ?? '',

      fecha: map['fecha'] ?? '',

      estado: map['estado'] ?? '',
    );
  }
}
