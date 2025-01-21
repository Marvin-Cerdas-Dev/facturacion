// Clase base para representar una entrada de tabla
class TableEntry {
  final String code;
  final String description;

  const TableEntry({this.code = '', this.description = ''});

  String get getCode => code;
  String get getDescription => description;
}

// Clase para manejar las tablas de referencia
class ReferenceTable {
  final List<TableEntry> _entries;

  const ReferenceTable(this._entries);

  TableEntry? findByCode(String code) {
    try {
      return _entries.firstWhere((entry) => entry.code == code);
    } catch (e) {
      return null;
    }
  }

  TableEntry? findByDescription(String description) {
    try {
      return _entries.firstWhere(
        (entry) => entry.description.toLowerCase() == description.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  List<TableEntry> getAll() => List.unmodifiable(_entries);
}

// Tablas de referencia como objetos constantes
class ReferenceTables {
  // Tipos de documentos para la factura
  static const documentTypes = ReferenceTable([
    TableEntry(code: '01', description: 'Factura electrónica de venta'),
    TableEntry(
        code: '03',
        description: 'Instrumento electrónico de transmisión - tipo 03'),
  ]);

  // Códigos de corrección
  static const correctionCodes = ReferenceTable([
    TableEntry(
        code: '1',
        description:
            'Devolución parcial de los bienes y/o no aceptación parcial del servicio'),
    TableEntry(code: '2', description: 'Anulación de factura electrónica'),
    TableEntry(code: '3', description: 'Rebaja o descuento parcial o total'),
    TableEntry(code: '4', description: 'Ajuste de precio'),
    TableEntry(code: '5', description: 'Descuento comercial por pronto pago'),
    TableEntry(
        code: '6', description: 'Descuento comercial por volumen de ventas'),
  ]);

  // Tipos de operación
  static const operationTypes = ReferenceTable([
    TableEntry(
        code: '20',
        description: 'Nota Crédito que referencia una factura electrónica'),
    TableEntry(
        code: '22',
        description: 'Nota Crédito sin referencia a una factura electrónica'),
  ]);

  // Estándares de identificación del producto
  static const productStandards = ReferenceTable([
    TableEntry(
        code: '1', description: 'Estándar de adopción del contribuyente'),
    TableEntry(code: '2', description: 'UNSPSC'),
    TableEntry(code: '3', description: 'Partida Arancelaria'),
    TableEntry(code: '4', description: 'GTIN'),
  ]);

  // Conceptos de reclamo
  static const claimConcepts = ReferenceTable([
    TableEntry(code: '1', description: 'Documento con inconsistencias'),
    TableEntry(code: '2', description: 'Mercancía no entregada'),
    TableEntry(code: '3', description: 'Mercancía entregada parcialmente'),
    TableEntry(code: '4', description: 'Servicio no prestado'),
  ]);

  // Códigos de eventos
  static const eventCodes = ReferenceTable([
    TableEntry(
        code: '030',
        description: 'Acuse de recibo de Factura Electrónica de Venta'),
    TableEntry(
        code: '031', description: 'Reclamo de la Factura Electrónica de Venta'),
    TableEntry(
        code: '032',
        description: 'Recibo del bien y/o prestación del servicio'),
    TableEntry(code: '033', description: 'Aceptación expresa'),
    TableEntry(code: '034', description: 'Aceptación tácita'),
  ]);

  // Tipos de documentos de identidad
  static const identityDocumentTypes = ReferenceTable([
    TableEntry(code: '1', description: 'Registro civil'),
    TableEntry(code: '2', description: 'Tarjeta de identidad'),
    TableEntry(code: '3', description: 'Cédula de ciudadanía'),
    TableEntry(code: '4', description: 'Tarjeta de extranjería'),
    TableEntry(code: '5', description: 'Cédula de extranjería'),
    TableEntry(code: '6', description: 'NIT'),
    TableEntry(
        code: '8', description: 'Documento de identificación extranjero'),
    TableEntry(code: '9', description: 'PEP'),
    TableEntry(code: '10', description: 'NIT otro país'),
    TableEntry(code: '11', description: 'NUIP'),
  ]);

  // Tributos clientes
  static const clientTaxes = ReferenceTable([
    TableEntry(code: '18', description: 'IVA'),
    TableEntry(code: '21', description: 'No aplica'),
  ]);

  // Tipos de organizaciones
  static const organizationTypes = ReferenceTable([
    TableEntry(code: '1', description: 'Persona Jurídica'),
    TableEntry(code: '2', description: 'Persona Natural'),
  ]);

  // Métodos de pago
  static const paymentMethods = ReferenceTable([
    TableEntry(code: '10', description: 'Efectivo'),
    TableEntry(code: '42', description: 'Consignación'),
    TableEntry(code: '20', description: 'Cheque'),
    TableEntry(code: '47', description: 'Transferencia'),
    TableEntry(code: '71', description: 'Bonos'),
    TableEntry(code: '72', description: 'Vales'),
    TableEntry(code: '1', description: 'Medio de pago no definido'),
    TableEntry(code: '49', description: 'Tarjeta Débito'),
    TableEntry(code: '48', description: 'Tarjeta Crédito'),
    TableEntry(code: 'ZZZ', description: 'Otro'),
  ]);

  // Formas de pago
  static const paymentForms = ReferenceTable([
    TableEntry(code: '1', description: 'Pago de contado'),
    TableEntry(code: '2', description: 'Pago a crédito'),
  ]);

  // Tipos de documento para los rangos de numeración
  static const numberingRangeDocTypes = ReferenceTable([
    TableEntry(code: '21', description: 'Factura de Venta'),
    TableEntry(code: '22', description: 'Nota Crédito'),
    TableEntry(code: '23', description: 'Nota Débito'),
    TableEntry(code: '24', description: 'Documento Soporte'),
    TableEntry(code: '25', description: 'Nota de Ajuste Documento Soporte'),
    TableEntry(code: '26', description: 'Nómina'),
    TableEntry(code: '27', description: 'Nota de Ajuste Nómina'),
    TableEntry(code: '28', description: 'Nota de eliminación de nómina'),
    TableEntry(code: '30', description: 'Factura de talonario y de papel'),
  ]);
}
