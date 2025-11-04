import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../repository/models/ubicacion_model.dart';
import '../repository/models/almacen_model.dart';

class AlmacenService {
  final String baseUrl;

  AlmacenService({this.baseUrl = 'http://192.168.1.82:5138'});

  Future<List<AlmacenModel>> obtenerAlmacenes() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Almacen/listar'));
    debugPrint('Respuesta API almacenes: ${response.body}');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => AlmacenModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar almacenes');
    }
  }

  Future<List<UbicacionModel>> obtenerUbicacionesPorAlmacen(int idAlmacen) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Almacen/ubicaciones/$idAlmacen'));
    debugPrint('Respuesta API ubicaciones: ${response.body}');
    
    if (response.statusCode == 200) {
      try {
        final List data = jsonDecode(response.body);
        return data.map((item) => UbicacionModel.fromJson(item)).toList();
      } catch (e) {
        debugPrint('Error al parsear JSON: $e');
        return [];
      }
    } else {
      throw Exception('Error al cargar ubicaciones');
    }
  }
}
