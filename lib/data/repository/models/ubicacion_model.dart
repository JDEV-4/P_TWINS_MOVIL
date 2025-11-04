import '../../../domain/entities/ubicacion_entity.dart';

class UbicacionModel {
  final int id;
  final String nombre;

  UbicacionModel({required this.id, required this.nombre});

  factory UbicacionModel.fromJson(Map<String, dynamic> json) {
    return UbicacionModel(
      id: json['iD_Ubicacion'] ?? 0, // 🔹 coincide con JSON
      nombre: json['nombre'] ?? '-', // 🔹 coincide con JSON
    );
  }

  UbicacionEntity toEntity() => UbicacionEntity(id: id, nombre: nombre);
}
