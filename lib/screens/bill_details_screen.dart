import 'package:facturacion/data/bill.dart';
import 'package:facturacion/data/bill_details.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/services/auth_service.dart';
import 'package:facturacion/services/bill_service.dart';
import 'package:facturacion/widget/bill_details_widget.dart';
import 'package:flutter/material.dart';

class BillDetailsScreen extends StatefulWidget {
  const BillDetailsScreen({
    super.key,
    required this.bill,
  });

  final Bill bill;

  @override
  State<BillDetailsScreen> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetailsScreen> {
  late Future<Token> _token;
  late Bill _bill;
  late Future<BillDetails> _billDetails;

  @override
  void initState() {
    super.initState();
    _setToken();
    _bill = widget.bill;
    _getBillDetails();
  }

  void _setToken() async {
    _token = AuthService().getToken();
  }

  void _getBillDetails() async {
    _billDetails = BillService().getBillByNumber(_token, _bill.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Detalles de factura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: _billDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error al consultar los datos de la factura...');
            } else if (snapshot.hasData) {
              final billDetails = snapshot.data!;
              return BillDetailsWidget(billDetails: billDetails);
            } else {
              return Center(
                child: Text(''),
              );
            }
          },
        ),
      ),
    );
  }
}
