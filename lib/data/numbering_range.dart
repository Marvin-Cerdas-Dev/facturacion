class NumberRange {
  int idKey;
  int id;
  String document;
  String prefix;
  int from;
  int to;
  int current;
  String? resolutionNumber;
  String startDate;
  String endDate;
  String? technicalKey;
  bool isExpired;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;

  NumberRange({
    this.id = -1,
    this.document = '',
    this.prefix = '',
    this.from = -1,
    this.to = -1,
    this.current = -1,
    this.resolutionNumber = '',
    this.startDate = '',
    this.endDate = '',
    this.technicalKey = '',
    this.isExpired = false,
    this.isActive = -1,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : idKey = 0,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get getStringId => id.toString();
  String get getDocument => document;

  static List<NumberRange> fromJsonResponse(Map<String, dynamic> jsonResponse) {
    final List<dynamic> data = jsonResponse['data'];
    return data.map((json) => NumberRange.fromJson(json)).toList();
  }

  factory NumberRange.fromJson(Map<String, dynamic> json) => NumberRange(
        id: json["id"],
        document: json["document"],
        prefix: json["prefix"],
        from: json["from"],
        to: json["to"],
        current: json["current"],
        resolutionNumber: json["resolution_number"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        technicalKey: json["technical_key"],
        isExpired: json["is_expired"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_key": idKey,
        "id": id,
        "document": document,
        "prefix": prefix,
        "from": from,
        "to": to,
        "current": current,
        "resolution_number": resolutionNumber,
        "start_date": startDate,
        "end_date": endDate,
        "technical_key": technicalKey,
        "is_expired": isExpired,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toMap() => {
        "id_key": idKey,
        "id": id,
        "document": document,
        "prefix": prefix,
        "from": from,
        "to": to,
        "current": current,
        "resolution_number": resolutionNumber,
        "start_date": startDate,
        "end_date": endDate,
        "technical_key": technicalKey,
        "is_expired": isExpired ? 1 : 0,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'NumberRange{'
        'id_key: $idKey, '
        'id: $id, '
        'document: $document, '
        'prefix: $prefix, '
        'from: $from, '
        'to: $to, '
        'current: $current, '
        'resolution_number: $resolutionNumber, '
        'start_date: $startDate, '
        'end_Date: $endDate, '
        'technical_key: $technicalKey, '
        'is_expired: $isExpired, '
        'is_active: $isActive, '
        'created_at: $createdAt, '
        'updated_at: $updatedAt'
        '}';
  }
}
