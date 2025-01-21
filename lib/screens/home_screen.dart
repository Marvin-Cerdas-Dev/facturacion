import 'package:facturacion/data/bill.dart';
import 'package:facturacion/services/bill_service.dart';
import 'package:facturacion/widget/bill_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/screens/create_bill_screen.dart';
import 'package:facturacion/services/auth_service.dart';

// import 'package:facturacion/data/municipality.dart';
// import 'package:facturacion/services/municipality_service.dart';
// import 'package:facturacion/data/numbering_range.dart';
// import 'package:facturacion/services/numb_range_service.dart';
// import 'package:facturacion/data/tributes.dart';
// import 'package:facturacion/services/tribute_service.dart';
// import 'package:facturacion/data/measurement_units.dart';
// import 'package:facturacion/services/measurement_unit_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Token> _token;
  //late Future<List<NumberRange>> _numRange;
  //late Future<List<Municipality>> _numRange;
  //late Future<List<Tribute>> _numRange;
  //late Future<List<MeasurementUnit>> _numRange;
  late Future<List<Bill>> _bills;

  @override
  void initState() {
    super.initState();
    _setToken();
    _setNumbRange();
  }

  void _setNumbRange() async {
    //_numRange = NumbRangeService().getNumbRange(_token);
    //_numRange = MunicipalityService().getMunicipalities(_token);
    //_numRange = 
    //_numRange = MeasurementUnitService().getMeasurementUnits(_token);
    _bills = BillService().getBills(_token);
  }

  void _setToken() async {
    _token = AuthService().getToken();
  }

  void _showCreateBillScreen() {
    setState(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CreateBillScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Listado de Facturas'),
      ),
      body: Center(
        child: BillListWidget(bills: _bills),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateBillScreen,
        tooltip: 'Crea una nueva factura',
        child: const Icon(Icons.add),
      ),
    );
  }
}
