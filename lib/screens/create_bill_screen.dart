import 'dart:math';

import 'package:facturacion/data/bill.dart';
import 'package:facturacion/data/bill_request.dart';
import 'package:facturacion/data/customer.dart';
import 'package:facturacion/data/item.dart';
import 'package:facturacion/data/legal_organization.dart';
import 'package:facturacion/data/municipality.dart';
import 'package:facturacion/data/numbering_range.dart';
import 'package:facturacion/data/tributes.dart';
import 'package:facturacion/screens/add_products.dart';
import 'package:facturacion/services/auth_service.dart';
import 'package:facturacion/data/tables.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/services/bill_service.dart';
import 'package:facturacion/services/municipality_service.dart';
import 'package:facturacion/services/numb_range_service.dart';
import 'package:facturacion/services/tribute_service.dart';
import 'package:flutter/material.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  late Future<Token> _token;
  final _formKey = GlobalKey<FormState>();
  late Future<List<NumberRange>> _numRanges;
  int numberRangeCode = -1;
  late Future<List<Municipality>> _municipalities;
  String municipalityId = "";
  late Future<List<Tribute>> _tributes;
  String tributeId = "";
  List<Item> billProducts = [];
  late bool requestAnswer;

  @override
  void initState() {
    super.initState();
    _setToken();
    loadData();
  }

  void _setToken() async {
    _token = AuthService().getToken();
  }

  Future<List<dynamic>> loadData() {
    _numRanges = NumbRangeService().getNumbRange(_token);
    _municipalities = MunicipalityService().getMunicipalities(_token);
    _tributes = TributeService().getTributes(_token);
    return Future.wait([_numRanges, _municipalities, _tributes]);
  }

  @override
  Widget build(BuildContext context) {
    // Variables del formulario
    // ----- Variables de las factura -----
    final documentTypes = ReferenceTables.documentTypes.getAll();
    String? documentTypeCode;
    String? observation;
    final paymentMethod = ReferenceTables.paymentMethods.getAll();
    String? paymentMethodCode;
    // ----- Variables del cliente -------
    final customerIdentificationDocument =
        ReferenceTables.identityDocumentTypes.getAll();
    String? customerIdentificationDocumentCode;
    String? custumerId;
    String? custumerCompany;
    String? custumerName;
    String? custumerAddress;
    String? custumerEmail;
    String? custumerPhone;

    void _showAddProductsScreen() async {
      final List<Item>? result =
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddProductsScreen(
                    listItems: billProducts,
                  )));
      if (result != null) {
        setState(() {
          billProducts = result;
        });
      }
    }

    void createBill() async {
      try {
        int random = Random().nextInt(99);
        final lOrganization = LegalOrganization();
        final tributeList = await _tributes;
        final tribute = tributeList.firstWhere((element) {
          return element.id == int.parse(tributeId);
        });
        final municipalityList = await _municipalities;
        final muni = municipalityList.firstWhere((element) {
          return element.id == int.parse(municipalityId);
        });
        final token = await _token;
        Customer newCustomer = Customer(
          identification: custumerId,
          names: custumerName,
          address: custumerAddress,
          email: custumerEmail,
          phone: custumerPhone,
          legalOrganization: lOrganization,
          tribute: tribute,
          municipality: muni,
          identificationDocumentId: customerIdentificationDocumentCode,
          company: custumerCompany,
        );
        BillRequest request = BillRequest(
          document: documentTypeCode,
          numberingRangeId: numberRangeCode,
          referenceCode: "fact00450$random",
          observation: observation,
          paymentMethodCode: paymentMethodCode,
          customer: newCustomer,
          items: billProducts,
        );
        requestAnswer =
            await BillService().createBill(request, token.access_token);
        if(requestAnswer == false){
          // Mensaje de error.
        }
        if (mounted && requestAnswer) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Formulario válido')),
          );
          setState(() {
            Navigator.pop(context, requestAnswer);
          });
        }
      } catch (e) {
        print('Error al crear la factura: -> $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Crear Nueva Factura'),
      ),
      body: Center(
        child: FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Cargando datos..."),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator(),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              // Definicion de variales Future
              final futuresVars = snapshot.data as List;
              final numbRanges = futuresVars[0] as List<NumberRange>;
              final municipalities = futuresVars[1] as List<Municipality>;
              final tributes = futuresVars[2] as List<Tribute>;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Información de la factura",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Tipo de documento
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Tipo de documento',
                            border: OutlineInputBorder(),
                          ),
                          items: documentTypes
                              .map((entry) => DropdownMenuItem(
                                  value: entry.code,
                                  child: Text(entry.description)))
                              .toList(),
                          onChanged: (value) {
                            documentTypeCode = value;
                            //print('Document Type Seleccionado: $value');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, seleccione una opción';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Rango de numeración
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Rango de Numeración',
                            border: OutlineInputBorder(),
                          ),
                          items: numbRanges
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.getStringId,
                                  child: Text(
                                    entry.getDocument,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            numberRangeCode = int.parse(value!);
                            //print('Document Type Seleccionado: $value');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, seleccione una opción';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Observacion
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Observación',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Se debe agregar una observación';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            observation = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Medio de pago
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Método de pago',
                            border: OutlineInputBorder(),
                          ),
                          items: paymentMethod
                              .map((entry) => DropdownMenuItem(
                                  value: entry.code,
                                  child: Text(entry.description)))
                              .toList(),
                          onChanged: (value) {
                            paymentMethodCode = value;
                            //print('Document Type Seleccionado: $value');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, seleccione una opción';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Información del cliente",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // --------- Informacion del cliente --------------
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Tipo de Identificación del cliente',
                            border: OutlineInputBorder(),
                          ),
                          items: customerIdentificationDocument
                              .map((entry) => DropdownMenuItem(
                                  value: entry.code,
                                  child: Text(entry.description)))
                              .toList(),
                          onChanged: (value) {
                            customerIdentificationDocumentCode = value;
                            //print('Document Type Seleccionado: $value');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, seleccione una opción';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Número de identificación del cliente.
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Número de Identificación del cliente',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Se debe agregar el número de identificación';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            custumerId = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Compañia
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Compañia',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            custumerCompany = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Nombre
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nombre del cliente',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Se debe agregar un nombre';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            custumerName = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Dirrección
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Dirección del cliente',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Se debe agregar una dirección';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            custumerAddress = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Email
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico del cliente',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Se debe agregar una dirreción de correo';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            custumerEmail = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Teléfono
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Número de teléfono del cliente',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Se debe agregar un número de teléfono';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            custumerPhone = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Tributo
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Tributo',
                            border: OutlineInputBorder(),
                          ),
                          items: tributes
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.getStringId,
                                  child: Text(
                                    entry.getName,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            tributeId = value!;
                            //print('Document Type Seleccionado: $value');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, seleccione una opción';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Municipio
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Municipio',
                            border: OutlineInputBorder(),
                          ),
                          items: municipalities
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.getStringId,
                                  child: Text(
                                    entry.getName,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            municipalityId = value!;
                            //print('Document Type Seleccionado: $value');
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, seleccione una opción';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Productos
                        Text(
                          "Información de los productos",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Listado de productos agregados
                        SizedBox(
                          height: 290,
                          child: ListView.builder(
                            itemCount: billProducts.length,
                            itemBuilder: (context, index) {
                              final item = billProducts[index];
                              return Card(
                                shadowColor: Colors.blueGrey,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 20, bottom: 20, start: 10, end: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Descripción: ${item.name}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Cantidad ${item.quantity}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "Precio unitario: ${item.price}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "Precio total: ${item.total}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: EdgeInsets.all(20),
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _showAddProductsScreen,
                            child: billProducts.isEmpty
                                ? Text('Agregar productos')
                                : Text('Agregar o editar productos'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Boton de envio del formulario
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 50,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: EdgeInsets.all(20),
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                createBill();
                              }
                            },
                            child: Text('Crear y validar la factura'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
