import 'package:facturacion/data/measurement_units.dart';
import 'package:facturacion/data/tables.dart';
import 'package:facturacion/data/tributes.dart';
import 'package:facturacion/data/withholdingTax.dart';

class Item {
  String codeReference;
  String name;
  int quantity;
  String discountRate;
  String discount;
  String grossValue;
  String taxRate;
  String taxableAmount;
  String taxAmount;
  String price;
  int isExcluded;
  MeasurementUnit unitMeasure;
  TableEntry standardCode;
  Tribute tribute;
  int total;
  List<WithholdingTax> withholdingTaxes;

  Item({
    this.codeReference = '',
    this.name = '',
    this.quantity = -1,
    this.discountRate = '',
    this.discount = '',
    this.grossValue = '',
    this.taxRate = '',
    this.taxableAmount = '',
    this.taxAmount = '',
    this.price = '',
    this.isExcluded = -1,
    MeasurementUnit? unitMeasure,
    TableEntry? standardCode,
    Tribute? tribute,
    this.total = -1,
    List<WithholdingTax>? withholdingTaxes,
  })  : unitMeasure = unitMeasure ?? MeasurementUnit(),
        standardCode = standardCode ?? TableEntry(),
        tribute = tribute ?? Tribute(),
        withholdingTaxes = withholdingTaxes ?? [];

  String get getCodeReferense => codeReference;
  String get getName => name;

  void calculateTotal() {
    total = quantity * int.parse(price);
  }

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        codeReference: json["code_reference"],
        name: json["name"],
        quantity: json["quantity"],
        discountRate: json["discount_rate"],
        discount: json["discount"],
        grossValue: json["gross_value"],
        taxRate: json["tax_rate"],
        taxableAmount: json["taxable_amount"],
        taxAmount: json["tax_amount"],
        price: json["price"],
        isExcluded: json["is_excluded"],
        unitMeasure: MeasurementUnit.fromJson(json["unit_measure"]),
        standardCode: ReferenceTables.productStandards
            .findByCode(json["standard_code"]["code"]),
        tribute: Tribute.fromJson(json["tribute"]),
        total: json["total"],
        withholdingTaxes: List<WithholdingTax>.from(
            json["withholding_taxes"].map((x) => WithholdingTax.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    return {
      "code_reference": codeReference,
      "name": name,
      "quantity": quantity,
      "discount": discount,
      "discount_rate": discountRate,
      "price": price,
      "tax_rate": taxRate,
      "unit_measure_id": unitMeasure.id,
      "gross_value": grossValue,
      "taxable_amount": taxableAmount,
      "tax_amount": taxAmount,
      "is_excluded": isExcluded,
      "standard_code_id": int.parse(standardCode.code),
      "tribute_id": tribute.id,
      "total": total,
      "withholding_taxes": withholdingTaxes.map((tax) => tax.toJson()).toList(),
    };
  }
}
