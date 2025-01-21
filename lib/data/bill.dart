import 'dart:convert';
import 'package:facturacion/data/tables.dart';

class Bill {
  int id;
  TableEntry document;
  String number;
  String apiClientName;
  String? referenceCode;
  String identification;
  String graphicRepresentationName;
  String company;
  String? tradeName;
  String names;
  String email;
  String total;
  int status;
  List<String> errors;
  int sendEmail;
  int hasClaim;
  int isNegotiableInstrument;
  TableEntry paymentForm;
  String createdAt;
  List<dynamic> creditNotes;
  List<dynamic> debitNotes;

  Bill({
    this.id = -1,
    TableEntry? document,
    this.number = '',
    this.apiClientName = '',
    this.referenceCode = '',
    this.identification = '',
    this.graphicRepresentationName = '',
    this.company = '',
    this.tradeName = '',
    this.names = '',
    this.email = '',
    this.total = '',
    this.status = -1,
    List<String>? errors,
    this.sendEmail = -1,
    this.hasClaim = -1,
    this.isNegotiableInstrument = -1,
    TableEntry? paymentForm,
    this.createdAt = '',
    List<dynamic>? creditNotes,
    List<dynamic>? debitNotes,
  }) : errors = errors ?? [],
  paymentForm = paymentForm ?? TableEntry(),
  creditNotes = creditNotes ?? [],
  debitNotes = debitNotes ?? [],  
  document = document ?? TableEntry();

  // Solución 1: Usando UTF8 decoder recursivo
  static List<Bill> fromJsonResponse(Map<String, dynamic> jsonResponse) {
    final List<dynamic> data = jsonResponse['data']['data'];

    return data.map((json) {
      final Map<String, dynamic> decodedJson = _decodeMap(json);
      return Bill.fromJson(decodedJson);
    }).toList();
  }

  // Función auxiliar para decodificar recursivamente
  static dynamic _decodeMap(dynamic value) {
    if (value is Map) {
      return value.map((key, value) => MapEntry(
            key.toString(),
            _decodeMap(value),
          ));
    } else if (value is List) {
      return value.map((v) => _decodeMap(v)).toList();
    } else if (value is String) {
      try {
        // Intenta decodificar si es necesario
        String decodedValue =
            utf8.decode(value.codeUnits, allowMalformed: true);
        return decodedValue;
      } catch (e) {
        // Si falla la decodificación, retorna el valor original
        return value;
      }
    }
    return value;
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      document: ReferenceTables.documentTypes.findByCode(json['document']['code']),
      number: json['number'],
      apiClientName: json['api_client_name'],
      referenceCode: json['reference_code'],
      identification: json['identification'],
      graphicRepresentationName: json['graphic_representation_name'],
      company: json['company'],
      tradeName: json['trade_name'],
      names: json['names'],
      email: json['email'],
      total: json['total'],
      status: json['status'],
      errors: List<String>.from(json['errors']),
      sendEmail: json['send_email'],
      hasClaim: json['has_claim'],
      isNegotiableInstrument: json['is_negotiable_instrument'],
      paymentForm: ReferenceTables.paymentForms.findByCode(json['payment_form']['code']),
      createdAt: json['created_at'],
      creditNotes: json['credit_notes'],
      debitNotes: json['debit_notes'],
    );
  }
}
