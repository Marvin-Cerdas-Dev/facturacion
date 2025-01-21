class LegalOrganization {
    int id;
    String code;
    String name;

    LegalOrganization({
        this.id = 2,
        this.code = 'P23449',
        this.name = 'Organización de prueba',
    });

    factory LegalOrganization.fromJson(Map<String, dynamic> json) => LegalOrganization(
        id: json["id"],
        code: json["code"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
    };
}