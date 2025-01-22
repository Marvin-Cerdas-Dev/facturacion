import 'package:facturacion/data/bill.dart';
import 'package:facturacion/widget/bill_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/screens/create_bill_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  void _showCreateBillScreen() async {
    final request = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateBillScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Listado de Facturas'),
      ),
      body: Center(
        //child: BillListWidget(bills: _bills),
        child: BillListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateBillScreen,
        tooltip: 'Crea una nueva factura',
        child: const Icon(Icons.add),
      ),
    );
  }
}
