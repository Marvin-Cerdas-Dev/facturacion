import 'dart:convert';

class MeasurementUnit {
  int idKey;
  int id;
  String code;
  String name;

  MeasurementUnit({
    this.id = -1,
    this.code = '',
    this.name = '',
  }) : idKey = 0;

  static List<MeasurementUnit> fromJsonResponse(
      Map<String, dynamic> jsonResponse) {
    final List<dynamic> data = jsonResponse['data'];

    return data.map((json) {
      final Map<String, dynamic> decodedJson =
          (json as Map<dynamic, dynamic>).map((key, value) => MapEntry(
                key.toString(),
                value is String ? utf8.decode(value.runes.toList()) : value,
              ));
      return MeasurementUnit.fromJson(decodedJson);
    }).toList();
  }

  factory MeasurementUnit.fromJson(Map<String, dynamic> json) =>
      MeasurementUnit(
        id: json["id"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id_key": idKey,
        "id": id,
        "code": code,
        "name": name,
      };

  Map<String, dynamic> toMap() => {
        "id_key": idKey,
        "id": id,
        "code": code,
        "name": name,
      };
}
