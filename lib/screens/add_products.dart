import 'package:facturacion/data/item.dart';
import 'package:facturacion/services/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({super.key, required this.listItems});

  final List<Item> listItems;

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  List<Item> items = ItemProducts().createProducts();
  List<Item> addedItems = [];
  Item? tempItem;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    addedItems = widget.listItems;
  }

  void _showAddItemDialog() {
    final _formAddKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Selecione el producto a agregar',
              style: TextStyle(fontSize: 20),
            ),
            content: Form(
              key: _formAddKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Nombre del producto',
                      border: OutlineInputBorder(),
                    ),
                    items: items
                        .map(
                          (entry) => DropdownMenuItem(
                            value: entry.getCodeReferense,
                            child: Text(
                              entry.getName,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      tempItem = items.firstWhere((element) {
                        return element.codeReference == value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, seleccione una opción';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Ingrese la cantidad',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.parse(value) <= 0) {
                        return 'Se debe agregar una cantidad';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      quantity = int.parse(value);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.all(10),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (_formAddKey.currentState!.validate()) {
                    tempItem!.quantity = quantity;
                    tempItem!.calculateTotal();
                    setState(() {
                      addedItems.add(tempItem!);
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('Agregar producto'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.all(10),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Agregar productos'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _showAddItemDialog,
              icon: Icon(Icons.add),
            ),
          ),
          if (addedItems.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context, addedItems);
                  //print(addedItems);
                },
                icon: Icon(Icons.check),
              ),
            ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
              itemCount: addedItems.length,
              itemBuilder: (context, index) {
                final items = addedItems[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
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
                                items.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Cantidad ${items.quantity}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Precio unitario ${items.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          Text(
                            items.total.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
