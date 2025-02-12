import 'package:facturacion/data/legal_organization.dart';
import 'package:facturacion/data/municipality.dart';
import 'package:facturacion/data/tributes.dart';

class Customer {
  String? identification;
  dynamic dv;
  String graphicRepresentationName;
  String tradeName;
  String? company;
  String? names;
  String? address;
  String? email;
  String? phone;
  LegalOrganization legalOrganization;
  Tribute tribute;
  String? identificationDocumentId;
  dynamic municipality;

  Customer({
    this.identification = '',
    this.dv = '',
    this.graphicRepresentationName = '',
    this.tradeName = '',
    this.company = '',
    this.names = '',
    this.address = '',
    this.email = '',
    this.phone = '',
    LegalOrganization? legalOrganization,
    Tribute? tribute,
    this.identificationDocumentId = "",
    Municipality? municipality,
  })  : legalOrganization = legalOrganization ?? LegalOrganization(),
        tribute = tribute ?? Tribute(),
        municipality = municipality ?? Municipality();

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        identification: json["identification"],
        dv: json["dv"],
        graphicRepresentationName: json["graphic_representation_name"],
        tradeName: json["trade_name"],
        company: json["company"],
        names: json["names"],
        address: json["address"],
        email: json["email"],
        phone: json["phone"],
        legalOrganization:
            LegalOrganization.fromJson(json["legal_organization"]),
        tribute: Tribute.fromJson(json["tribute"]),
        municipality: json["municipality"] is Map
            ? Municipality.fromJson(json["municipality"])
            : (json["municipality"] is List && json["municipality"].isNotEmpty
                ? Municipality.fromJson(json["municipality"][0])
                : null),
      );

  Map<String, dynamic> toJson() => {
        "identification": identification,
        "company": company,
        "trade_name": tradeName,
        "names": names,
        "address": address,
        "email": email,
        "phone": phone,
        "legal_organization_id": legalOrganization.code,
        "tribute_id": tribute.code,
        "identification_document_id": identificationDocumentId,
        "municipality": municipality.code,
      };
}
