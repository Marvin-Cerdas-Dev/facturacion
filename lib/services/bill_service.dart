import 'dart:convert';
import 'package:facturacion/data/bill.dart';
import 'package:facturacion/data/bill_details.dart';
import 'package:facturacion/data/bill_request.dart';
import 'package:facturacion/data/token.dart';
import 'package:http/http.dart' as http;

class BillService {
  final listUri = Uri.parse(
      'https://api-sandbox.factus.com.co/v1/bills?filter[names]=Marvin Cerdas');
  final validUri =
      Uri.parse('https://api-sandbox.factus.com.co/v1/bills/validate');
  final ulritest = Uri.parse(
      'https://api-sandbox.factus.com.co/v1/bills/validate/name/test');
  String viewkUri = 'https://api-sandbox.factus.com.co/v1/bills/show/';

  Future<List<Bill>> fetchBillList(String token) async {
    final response = await http.get(listUri, headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Bill.fromJsonResponse(jsonResponse);
    } else {
      throw Exception('Error consultando BillList: ${response.body}');
    }
  }

  Future<List<Bill>> getBills(Future<Token> token) async {
    final loadedToken = await token;
    List<Bill>? bills;

    try {
      bills = await fetchBillList(loadedToken.acessToken);
      return bills;
    } catch (e) {
      //print('Error al retoranar List<Bill>: $e');
    }
    return [];
  }

  Future<BillDetails> fetchBillByNumber(String token, String number) async {
    final url = Uri.parse('$viewkUri$number');
    final response = await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      return BillDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error consultando Bill por número: ${response.body}');
    }
  }

  Future<BillDetails> getBillByNumber(
      Future<Token> token, String billNumber) async {
    final loadedToken = await token;
    BillDetails bill;

    try {
      bill = await fetchBillByNumber(loadedToken.acessToken, billNumber);
      return bill;
    } catch (e) {
      //print('Error al retoranar BillDetails: $e');
      return BillDetails();
    }
  }

  Future<bool> createBill(BillRequest billRequest, String token) async {
    final requestHeader = <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final requestBody = jsonEncode(<String, dynamic>{
      "document": billRequest.document,
      "numbering_range_id": billRequest.numberingRangeId,
      "reference_code": billRequest.referenceCode,
      "observation": billRequest.observation,
      "payment_method_code": billRequest.paymentMethodCode,
      "customer": billRequest.customer.toJson(),
      "items": billRequest.items.map((item) => item.toJson()).toList(),
    });
    print(requestBody);
    final response =
        await http.post(validUri, headers: requestHeader, body: requestBody);

    if (response.statusCode == 201) {
      return true;
    } else if ((response.statusCode == 409)) {
      print("Error 409 al crear la factura: => ${response.body}");
    } else if ((response.statusCode == 422)) {
      print("Error 422 en los datos de la factura: => ${response.body}");
    } else if ((response.statusCode == 404)) {
      print("Ruta no valida: => ${response.body}");
    }
    return false;
  }
}
