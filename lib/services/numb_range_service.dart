import 'dart:convert';

import 'package:facturacion/data/numbering_range.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/services/storage_service.dart';
import 'package:http/http.dart' as http;

class NumbRangeService {
  final _storageService = StorageService();
  final uri =
      Uri.parse('https://api-sandbox.factus.com.co/v1/numbering-ranges');

  Future<List<NumberRange>> fetchNumbersRages(String token) async {
    final response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return NumberRange.fromJsonResponse(jsonResponse);
    } else {
      throw Exception('Failed to load token: ${response.body}');
    }
  }

  Future<List<NumberRange>> getNumbRange(Future<Token> token) async {
    final loadedToken = await token;
    List<NumberRange>? numberRange;

    try {
      numberRange = await _storageService.getAllNumberRange();
      //print('Number of Range encontrado en almacenamiento');
    } catch (e) {
      //print('No se encontró Number of Range en almacenamiento: $e');
      numberRange = null;
    }

    if (numberRange == null || numberRange.isEmpty) {
      numberRange = await fetchNumbersRages(loadedToken.acessToken);
      insertNumberRanges(numberRange);
      return numberRange;
    }
    return [];
  }

  void insertNumberRanges(List<NumberRange> list) async {
    for (var numbRange in list) {
      try {
        await _storageService.insertNumberRange(numbRange);
        //print('Insertado correctamente: ${numbRange.document}');
      } catch (e) {
        //print('Error al insertar NumberRange ${numbRange.document}: $e');
        continue;
      }
    }
  }
}
