import 'dart:convert';

import 'package:facturacion/data/municipality.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/services/storage_service.dart';
import 'package:http/http.dart' as http;

class MunicipalityService {
  final _storageService = StorageService();
  final uri = Uri.parse('https://api-sandbox.factus.com.co/v1/municipalities');

  Future<List<Municipality>> fetchMunicipalities(String token) async {
    final response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Municipality.fromJsonResponse(jsonResponse);
    } else {
      throw Exception('Failed to load token: ${response.body}');
    }
  }

  Future<List<Municipality>> getMunicipalities(Future<Token> token) async {
    final loadedToken = await token;
    List<Municipality>? municipality;

    // ignore: unnecessary_null_comparison
    if (municipality == null || municipality.isEmpty) {
      municipality = await fetchMunicipalities(loadedToken.acessToken);
      insertMunicipalities(municipality);
      return municipality;
    }
    return municipality;
  }

  void insertMunicipalities(List<Municipality> list) async {
    for (var municipality in list) {
      try {
        await _storageService.insertMunicipality(municipality);
        //print('Insertado correctamente: ${municipality.department}');
      } catch (e) {
        //print('Error al insertar Municipality ${municipality.department}: $e');
        continue;
      }
    }
  }
}
