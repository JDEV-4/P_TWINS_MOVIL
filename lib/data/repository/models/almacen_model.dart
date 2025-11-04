import '../../../domain/entities/almacen_entity.dart';

class AlmacenModel {
  final int id;
  final String nombre;

  AlmacenModel({required this.id, required this.nombre});

  factory AlmacenModel.fromJson(Map<String, dynamic> json) {
    return AlmacenModel(
      id: json['id_Almacen'] ?? json['id'] ?? 0,
      nombre: json['nombre'] ?? '-',
    );
  }

  AlmacenEntity toEntity() => AlmacenEntity(id: id, nombre: nombre);
}
