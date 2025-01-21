class Rate {
  String code;
  String name;
  String rate;

  Rate({
    this.code = '',
    this.name = '',
    this.rate = '',
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        code: json["code"],
        name: json["name"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "rate": rate,
      };
}
