import 'dart:convert';
import 'package:facturacion/data/measurement_units.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/services/storage_service.dart';
import 'package:http/http.dart' as http;

class MeasurementUnitService {
  final _storageService = StorageService();
  final uri =
      Uri.parse('https://api-sandbox.factus.com.co/v1/measurement-units');

  Future<List<MeasurementUnit>> fetchMeasurementUnit(String token) async {
    final response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return MeasurementUnit.fromJsonResponse(jsonResponse);
    } else {
      throw Exception('Failed to load token: ${response.body}');
    }
  }

  Future<List<MeasurementUnit>> getMeasurementUnits(Future<Token> token) async {
    final loadedToken = await token;
    List<MeasurementUnit>? measurementUnit;

    try {
      measurementUnit = await _storageService.getAllMeasurementUnits();
      //print('Measurement Units encontrado en almacenamiento');
    } catch (e) {
      //print('No se encontró Measurement Units en almacenamiento: $e');
      measurementUnit = null;
    }

    if (measurementUnit == null || measurementUnit.isEmpty) {
      measurementUnit = await fetchMeasurementUnit(loadedToken.acessToken);
      insertMunicipalities(measurementUnit);
      return measurementUnit;
    }
    return [];
  }

  void insertMunicipalities(List<MeasurementUnit> list) async {
    for (var measurementUnit in list) {
      try {
        await _storageService.insertMeasurementUnits(measurementUnit);
        //print('Insertado correctamente: ${measurementUnit.name}');
      } catch (e) {
        //print('Error al insertar Measurement Unit ${measurementUnit.name}: $e');
        continue;
      }
    }
  }
}
