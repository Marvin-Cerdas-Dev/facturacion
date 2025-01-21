import 'dart:convert';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/data/tributes.dart';
import 'package:facturacion/services/storage_service.dart';
import 'package:http/http.dart' as http;

class TributeService {
  final _storageService = StorageService();
  final uri =
      Uri.parse('https://api-sandbox.factus.com.co/v1/tributes/products?name=');

  Future<List<Tribute>> fetchTributes(String token) async {
    final response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Tribute.fromJsonResponse(jsonResponse);
    } else {
      throw Exception('Failed to load token: ${response.body}');
    }
  }

  Future<List<Tribute>> getTributes(Future<Token> token) async {
    final loadedToken = await token;
    List<Tribute>? tribute;

    // ignore: unnecessary_null_comparison
    if (tribute == null || tribute.isEmpty) {
      tribute = await fetchTributes(loadedToken.acessToken);
      insertMunicipalities(tribute);
      return tribute;
    }
    return tribute;
  }

  void insertMunicipalities(List<Tribute> list) async {
    for (var tribute in list) {
      try {
        await _storageService.insertTribute(tribute);
        //print('Insertado correctamente: ${tribute.description}');
      } catch (e) {
        //print('Error al insertar Tribute ${tribute.description}: $e');
        continue;
      }
    }
  }
}
