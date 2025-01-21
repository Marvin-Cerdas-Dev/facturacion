import 'package:facturacion/data/customer.dart';
import 'package:facturacion/data/item.dart';

class BillRequest {
  String? document;
  int numberingRangeId;
  String referenceCode;
  String? observation;
  String? paymentMethodCode;
  Customer customer;
  List<Item> items;

  BillRequest({
    this.document = "",
    required this.numberingRangeId,
    required this.referenceCode,
    required this.observation,
    required this.paymentMethodCode,
    required this.customer,
    required this.items,
  });

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
