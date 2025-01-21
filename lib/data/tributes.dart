import 'dart:convert';

class Tribute {
  int idKey;
  int id;
  String code;
  String name;
  String description;

  Tribute({
    this.id = -1,
    this.code = '',
    this.name = '',
    String? description,
  })  : idKey = 0,
        description = description ?? '';

  String get getStringId => id.toString();
  String get getName => name;

  static List<Tribute> fromJsonResponse(Map<String, dynamic> jsonResponse) {
    final List<dynamic> data = jsonResponse['data'];

    return data.map((json) {
      final Map<String, dynamic> decodedJson =
          (json as Map<dynamic, dynamic>).map((key, value) => MapEntry(
                key.toString(),
                value is String ? utf8.decode(value.runes.toList()) : value,
              ));
      return Tribute.fromJson(decodedJson);
    }).toList();
  }

  factory Tribute.fromJson(Map<String, dynamic> json) => Tribute(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id_key": idKey,
        "id": id,
        "code": code,
        "name": name,
        "description": description,
      };

  Map<String, dynamic> toMap() => {
        "id_key": idKey,
        "id": id,
        "code": code,
        "name": name,
        "description": description,
      };
}
