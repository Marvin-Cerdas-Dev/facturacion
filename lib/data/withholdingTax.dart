import 'package:facturacion/data/rate.dart';

class WithholdingTax {
  String tributeCode;
  String name;
  String value;
  List<Rate>? rates;

  WithholdingTax({
    this.tributeCode = '',
    this.name = '',
    this.value = '',
    List<Rate>? rates,
  }) : rates = rates ?? [];

  factory WithholdingTax.fromJson(Map<String, dynamic> json) => WithholdingTax(
        tributeCode: json["tribute_code"],
        name: json["name"],
        value: json["value"],
        rates: json["rates"] == null
            ? []
            : List<Rate>.from(json["rates"]!.map((x) => Rate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tribute_code": tributeCode,
        "name": name,
        "value": value,
        "rates": rates == null
            ? []
            : List<dynamic>.from(rates!.map((x) => x.toJson())),
      };
}
