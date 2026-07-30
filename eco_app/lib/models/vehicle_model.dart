class VehicleModel {
  final String id;
  final String placa;
  final String tipo;
  final String conductor;
  final String estado;
  final String ubicacion;
  final String capacidad;

  VehicleModel({
    required this.id,
    required this.placa,
    required this.tipo,
    required this.conductor,
    required this.estado,
    required this.ubicacion,
    required this.capacidad,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'].toString(),

      placa: map['placa'] ?? '',

      tipo: map['tipo'] ?? '',

      conductor: map['conductor'] ?? '',

      estado: map['estado'] ?? '',

      ubicacion: map['ubicacion'] ?? '',

      capacidad: map['capacidad'] ?? '',
    );
  }
}
