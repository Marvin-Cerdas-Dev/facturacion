import 'package:facturacion/data/item.dart';
import 'package:facturacion/data/measurement_units.dart';
import 'package:facturacion/data/tables.dart';
import 'package:facturacion/data/tributes.dart';

class ItemProducts {
  ItemProducts();

  List<Item> createProducts() {
    List<Item> products = [];
    final mesure = MeasurementUnit(id: 70, code: "94", name: "unidad");
    final standard = ReferenceTables.productStandards.findByCode("1");
    final tribute = Tribute(
        id: 1, code: "01", name: "IVA", description: "Impuesto sobre la venta");

    for (var i = 0; i < 3; i++) {
      String valor = (1 + i).toString();
      String price = ((i + 1) * 2500).toString();

      var newItem = Item(
        codeReference: '23456$valor',
        name: 'Producto de prueba $valor',
        quantity: 0,
        discount: "0",
        discountRate: "0",
        price: price,
        taxRate: "13.00",
        unitMeasure: mesure,
        standardCode: standard,
        isExcluded: 0,
        tribute: tribute
      );
      products.add(newItem);
    }
    return products;
  }
}
