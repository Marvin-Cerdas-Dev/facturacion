import 'dart:convert';

import 'package:facturacion/const/global_const.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/services/storage_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final uri = Uri.parse('https://api-sandbox.factus.com.co/oauth/token');

  Future<Token> getAuthToken() async {
    final response = await http.post(uri,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'grant_type': 'password',
          'client_id': GlobalConst.CLIENT_ID,
          'client_secret': GlobalConst.CLIENTE_SECRET,
          'username': GlobalConst.USER_NAME,
          'password': GlobalConst.PASSWORD,
        }));

    if (response.statusCode == 200) {
      return Token.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load token: ${response.body}');
    }
  }

  Future<Token> getFreshToken(String token, String refreshToken) async {
    final response = await http.post(uri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'grant_type': 'refresh_token',
          'client_id': GlobalConst.CLIENT_ID,
          'client_secret': GlobalConst.CLIENTE_SECRET,
          'refresh_token': refreshToken,
        }));

    if (response.statusCode == 200) {
      return Token.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load token: ${response.body}');
    }
  }

  Future<Token> getToken() async {
    final storageController = StorageService();
    Token? token;

    try {
      // 1. Get token from storage
      try {
        token = await storageController.getToken();
        //print('Token encontrado en almacenamiento');
      } catch (e) {
        //print('No se encontró token en almacenamiento: $e');
        token = null;
      }

      // 2. If token exist, check if it is expired
      if (token != null) {
        if (token.isExpired()) {
          //print('Token expirado, solicitando refresh token');
          try {
            // Request fresh token
            final newToken = await getFreshToken(
              token.access_token,
              token.refreshToken,
            );
            // Update the token in the storage
            await storageController.updateToken(newToken);
            //print('Token refrescado y actualizado');
            return newToken;
          } catch (e) {
            //print('Error al refrescar token: $e');
            token = null;
          }
        } else {
          //print('Token válido, no necesita renovación');
          return token;
        }
      }

      // 3. If the token does not exist o the fresh token fails. We request a new token.
      if (token == null) {
        //print('Solicitando nuevo token');
        final newToken = await getAuthToken();
        await storageController.insertToken(newToken);
        //print('Nuevo token obtenido y guardado');
        return newToken;
      }
      throw Exception('No se pudo obtener un token válido');
    } catch (e) {
      //print('Error en el proceso de obtención de token: $e');
      throw Exception('Error al obtener token: $e');
    }
  }
}
