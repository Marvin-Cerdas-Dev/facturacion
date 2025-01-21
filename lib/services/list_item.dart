import 'package:facturacion/data/item.dart';

class ItemProducts {
  ItemProducts();

  List<Item> createProducts() {
    List<Item> products = [];
    for (var i = 0; i < 3; i++) {
      String valor = (1 + i).toString();
      String price = ((i+1) * 2500).toString();
      var newItem = Item(
        codeReference: '23456$valor',
        name: 'Producto de prueba $valor',
        quantity: 0,
        discount: "0",
        discountRate: "0",
        price: price,
        taxRate: "5.00",
        isExcluded: 0,
      );
      products.add(newItem);
    }
    return products;
  }
}
