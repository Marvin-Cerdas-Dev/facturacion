import 'package:facturacion/data/bill.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/screens/bill_details_screen.dart';
import 'package:facturacion/services/auth_service.dart';
import 'package:facturacion/services/bill_service.dart';
import 'package:flutter/material.dart';

class BillListWidget extends StatefulWidget {
  const BillListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _BillListWidgetState();
}

class _BillListWidgetState extends State<BillListWidget> {
  late Future<List<Bill>> _bills;
  late Future<Token> _token;

  @override
  void initState() {
    super.initState();
    _setToken();
    _setBillList();
  }

  void _setToken() async {
    _token = AuthService().getToken();
  }

  Future<List<Bill>> _setBillList() async {
    _bills = BillService().getBills(_token);
    return _bills;
  }

  void _showBillDetailsScreen(Bill bill) {
    setState(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BillDetailsScreen(
            bill: bill,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _setBillList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Consultando facturas'),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error al consultar los datos...');
          // ignore: prefer_is_empty
        } else if (snapshot.hasData && snapshot.data!.length > 0) {
          final billList = snapshot.data!;
          return ListView.builder(
            itemCount: billList.length,
            itemBuilder: (context, index) {
              final bill = billList[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    _showBillDetailsScreen(billList[index]);
                  },
                  child: Card(
                    shadowColor: Colors.blueGrey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bill.document.description,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Factura # ${bill.number}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Fecha ${bill.createdAt}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 90,
                          ),
                          Icon(Icons.arrow_forward_outlined),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text(
              'No se encontraron facturas creadas',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
      },
    );
  }
}
