class ContainerModel {
  final int id;
  final String numeroContenedor;
  final String naviera;
  final String origen;
  final String destino;
  final String estado;
  final String ubicacionActual;

  ContainerModel({
    required this.id,
    required this.numeroContenedor,
    required this.naviera,
    required this.origen,
    required this.destino,
    required this.estado,
    required this.ubicacionActual,
  });

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      id: json['id'] ?? 0,

      numeroContenedor: json['numero_contenedor'] ?? '',

      naviera: json['naviera'] ?? '',

      origen: json['origen'] ?? '',

      destino: json['destino'] ?? '',

      estado: json['estado'] ?? '',

      ubicacionActual: json['ubicacion_actual'] ?? '',
    );
  }
}
