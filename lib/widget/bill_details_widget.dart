import 'package:facturacion/data/bill_details.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class BillDetailsWidget extends StatefulWidget {
  BillDetailsWidget({super.key, required this.billDetails});

  BillDetails billDetails;

  @override
  State<BillDetailsWidget> createState() => _BillDetailsWidgetState();
}

class _BillDetailsWidgetState extends State<BillDetailsWidget> {
  late BillDetails billDetails;

  @override
  void initState() {
    super.initState();
    billDetails = widget.billDetails;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Datos de la empresa
          Text(
            'Datos de la Empresa',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Nombre: ${billDetails.company.company}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Email: ${billDetails.company.email}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Teléfono: ${billDetails.company.phone}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Dirección: ${billDetails.company.direction}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          // Datos del cliente en la factura
          Text(
            'Datos del Cliente',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Tipo de cliente: ${billDetails.customer.legalOrganization.name}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Nombre: ${billDetails.customer.names}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Número de Identificación: ${billDetails.customer.identification}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Email: ${billDetails.customer.email}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Teléfono: ${billDetails.customer.phone}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Dirección: ${billDetails.customer.address}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          // Datos de la factura
          Text(
            'Datos de la Factura',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Número de factura: ${billDetails.bill.number}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Estado de la factura: ${billDetails.bill.status == 1 ? "Validada" : "Sin validar"}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Fecha de creación: ${billDetails.bill.createdAt}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'Fecha de validación: ${billDetails.bill.validated}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          // Datos de los Productos
          Text(
            'Listado de Productos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 290,
            child: ListView.builder(
              itemCount: billDetails.items.length,
              itemBuilder: (context, index) {
                final item = billDetails.items[index];
                return Card(
                  shadowColor: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        top: 20, bottom: 20, start: 10, end: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(
                          width: 100,
                        ),
                        Icon(Icons.arrow_forward_outlined),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // QR Code
          Text(
            'Código QR',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Center(
            child: QrImageView(
              data: billDetails.bill.qr,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Totales
          Text(
            'Montos Totales',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Subtotal: ${billDetails.bill.grossValue}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            'Descuento ${billDetails.bill.discountRate}%: ${billDetails.bill.discount}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            'Monto tasable: ${billDetails.bill.taxableAmount}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            'IVA: ${billDetails.bill.taxAmount}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            'Total: ${billDetails.bill.total}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
