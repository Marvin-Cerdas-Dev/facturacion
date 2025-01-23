import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:facturacion/data/bill.dart';
import 'package:facturacion/data/bill_details.dart';
import 'package:facturacion/data/bill_request.dart';
import 'package:facturacion/data/token.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class BillService {
  // Uri for request biill list
  final listUri = Uri.parse(
      'https://api-sandbox.factus.com.co/v1/bills?filter[names]=Marvin Cerdas');
  // Uri for create and validate a Bill
  final validUri =
      Uri.parse('https://api-sandbox.factus.com.co/v1/bills/validate');
  // Base Uri for view the details of a Bill.
  String viewkUri = 'https://api-sandbox.factus.com.co/v1/bills/show/';
  // Base Uri to request a PDF
  String pdfUri = 'https://api-sandbox.factus.com.co/v1/bills/download-pdf/';

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

  Future<String> fetchBillPDF(String token, String number) async {
    final url = Uri.parse('$pdfUri$number');
    final response = await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error consultando por el PDF: ${response.body}');
    }
  }

  Future<void> getPDF(Future<Token> token, String billNumber) async {
    final loadedToken = await token;
    String pdfResponse;

    try {
      pdfResponse = await fetchBillPDF(loadedToken.acessToken, billNumber);
      final Map<String, dynamic> jsonResponse = json.decode(pdfResponse);
      final String base64Pdf = jsonResponse['data']['pdf_base_64_encoded'];
      final String fileName = jsonResponse['data']['file_name'];

      // Decodificar el contenido Base64
      final Uint8List bytes = base64.decode(base64Pdf);

      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName.pdf';

      // Escribir el archivo
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Abrir el archivo
      final result = await OpenFile.open(filePath);
      print('Resultado de abrir el archivo: $result');
      await OpenFile.open(filePath);
    } catch (e) {
      print('Error al crear el PDF: $e');
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
