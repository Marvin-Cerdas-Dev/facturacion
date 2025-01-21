import 'dart:convert';

class Municipality {
  int idKey;
  int id;
  String code;
  String name;
  String department;

  Municipality({
    this.id = -1,
    this.code = '',
    this.name = '',
    String? department,
  })  : idKey = 0,
        department = department ?? '';

  String get getStringId => id.toString();
  String get getName => name;

  static List<Municipality> fromJsonResponse(
      Map<String, dynamic> jsonResponse) {
    final List<dynamic> data = jsonResponse['data'];

    // Procesar cada elemento asegurando que se adapte a Map<String, dynamic>.
    return data.map((json) {
      final Map<String, dynamic> decodedJson =
          (json as Map<dynamic, dynamic>).map((key, value) => MapEntry(
                key.toString(),
                value is String ? utf8.decode(value.runes.toList()) : value,
              ));
      return Municipality.fromJson(decodedJson);
    }).toList();
  }

  factory Municipality.fromJson(Map<String, dynamic> json) => Municipality(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        department: json["department"],
      );

  Map<String, dynamic> toJson() => {
        "id_key": idKey,
        "id": id,
        "code": code,
        "name": name,
        "department": department,
      };

  Map<String, dynamic> toMap() => {
        "id_key": idKey,
        "id": id,
        "code": code,
        "name": name,
        "department": department,
      };
}
