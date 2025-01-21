import 'dart:convert';

import 'package:facturacion/data/item.dart';

BillData billDataFromJson(String str) => BillData.fromJson(json.decode(str));

String billDataToJson(BillData data) => json.encode(data.toJson());

class BillData {
  String document;
  int numberingRangeId;
  String referenceCode;
  String observation;
  String paymentMethodCode;
  Customer customer;
  List<Item> items;

  BillData({
    required this.document,
    required this.numberingRangeId,
    required this.referenceCode,
    required this.observation,
    required this.paymentMethodCode,
    required this.customer,
    required this.items,
  });

  factory BillData.fromJson(Map<String, dynamic> json) => BillData(
        document: json["document"],
        numberingRangeId: json["numbering_range_id"],
        referenceCode: json["reference_code"],
        observation: json["observation"],
        paymentMethodCode: json["payment_method_code"],
        customer: Customer.fromJson(json["customer"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "document": document,
        "numbering_range_id": numberingRangeId,
        "reference_code": referenceCode,
        "observation": observation,
        "payment_method_code": paymentMethodCode,
        "customer": customer.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Customer {
  String identification;
  String company;
  String tradeName;
  String names;
  String address;
  String email;
  String phone;
  String legalOrganizationId;
  String tributeId;
  String identificationDocumentId;
  String municipalityId;

  Customer({
    required this.identification,
    required this.company,
    required this.tradeName,
    required this.names,
    required this.address,
    required this.email,
    required this.phone,
    required this.legalOrganizationId,
    required this.tributeId,
    required this.identificationDocumentId,
    required this.municipalityId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        identification: json["identification"],
        company: json["company"],
        tradeName: json["trade_name"],
        names: json["names"],
        address: json["address"],
        email: json["email"],
        phone: json["phone"],
        legalOrganizationId: json["legal_organization_id"],
        tributeId: json["tribute_id"],
        identificationDocumentId: json["identification_document_id"],
        municipalityId: json["municipality_id"],
      );

  Map<String, dynamic> toJson() => {
        "identification": identification,
        "company": company,
        "trade_name": tradeName,
        "names": names,
        "address": address,
        "email": email,
        "phone": phone,
        "legal_organization_id": legalOrganizationId,
        "tribute_id": tributeId,
        "identification_document_id": identificationDocumentId,
        "municipality_id": municipalityId,
      };
}

class WithholdingTax {
  String code;
  String withholdingTaxRate;

  WithholdingTax({
    required this.code,
    required this.withholdingTaxRate,
  });

  factory WithholdingTax.fromJson(Map<String, dynamic> json) => WithholdingTax(
        code: json["code"],
        withholdingTaxRate: json["withholding_tax_rate"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "withholding_tax_rate": withholdingTaxRate,
      };
}
