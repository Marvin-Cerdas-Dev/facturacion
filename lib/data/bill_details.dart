import 'package:facturacion/data/company.dart';
import 'package:facturacion/data/customer.dart';
import 'package:facturacion/data/item.dart';
import 'package:facturacion/data/numbering_rate.dart';
import 'package:facturacion/data/tables.dart';
import 'package:facturacion/data/withholdingTax.dart';

class BillDetails {
  Company company;
  Customer customer;
  NumberingRange numberingRange;
  BillClass bill;
  List<Item> items;
  List<WithholdingTax> withholdingTaxes;
  List<dynamic> creditNotes;
  List<dynamic> debitNotes;

  BillDetails({
    Company? company,
    Customer? customer,
    NumberingRange? numberingRange,
    BillClass? bill,
    List<Item>? items,
    List<WithholdingTax>? withholdingTaxes,
    List<dynamic>? creditNotes,
    List<dynamic>? debitNotes,
  })  : company = company ?? Company(),
        customer = customer ?? Customer(),
        numberingRange = numberingRange ?? NumberingRange(),
        bill = bill ?? BillClass(),
        items = items ?? [],
        withholdingTaxes = withholdingTaxes ?? [],
        creditNotes = creditNotes ?? [],
        debitNotes = debitNotes ?? [];

  factory BillDetails.fromJson(Map<String, dynamic> json) => BillDetails(
        company: Company.fromJson(json["data"]["company"] as Map<String, dynamic>),
        customer:
            Customer.fromJson(json["data"]["customer"]),
        numberingRange: NumberingRange.fromJson(json["data"]["numbering_range"]),
        bill: BillClass.fromJson(json["data"]["bill"]),
        items: List<Item>.from(json["data"]["items"].map((x) => Item.fromJson(x))),
        withholdingTaxes: List<WithholdingTax>.from(
            json["data"]["withholding_taxes"].map((x) => WithholdingTax.fromJson(x))),
        creditNotes: List<dynamic>.from(json["data"]["credit_notes"].map((x) => x)),
        debitNotes: List<dynamic>.from(json["data"]["debit_notes"].map((x) => x)),
      );
}

class BillClass {
  int id;
  String number;
  String referenceCode;
  int status;
  int sendEmail;
  String qr;
  String cufe;
  String validated;
  String discountRate;
  String discount;
  String grossValue;
  String taxableAmount;
  String taxAmount;
  String total;
  dynamic observation;
  List<String> errors;
  String createdAt;
  String paymentDueDate;
  String qrImage;
  TableEntry paymentMethod;

  BillClass({
    this.id = -1,
    this.number = '',
    this.referenceCode = '',
    this.status = -1,
    this.sendEmail = -1,
    this.qr = '',
    this.cufe = '',
    this.validated = '',
    this.discountRate = '',
    this.discount = '',
    this.grossValue = '',
    this.taxableAmount = '',
    this.taxAmount = '',
    this.total = '',
    this.observation = '',
    List<String>? errors,
    this.createdAt = '',
    this.paymentDueDate = '',
    this.qrImage = '',
    TableEntry? paymentMethod,
  })  : errors = errors ?? [],
        paymentMethod = paymentMethod ?? TableEntry();

  factory BillClass.fromJson(Map<String, dynamic> json) => BillClass(
        id: json["id"],
        number: json["number"],
        referenceCode: json["reference_code"],
        status: json["status"],
        sendEmail: json["send_email"],
        qr: json["qr"],
        cufe: json["cufe"],
        validated: json["validated"],
        discountRate: json["discount_rate"],
        discount: json["discount"],
        grossValue: json["gross_value"],
        taxableAmount: json["taxable_amount"],
        taxAmount: json["tax_amount"],
        total: json["total"],
        observation: json["observation"],
        errors: List<String>.from(json["errors"].map((x) => x)),
        createdAt: json["created_at"],
        paymentDueDate: json["payment_due_date"] ?? 'null',
        qrImage: json["qr_image"],
        paymentMethod:
            ReferenceTables.paymentMethods.findByCode(json["payment_method"]["code"]),
      );
}
