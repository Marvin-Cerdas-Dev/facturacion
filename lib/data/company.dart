class Company {
    String urlLogo;
    String nit;
    String dv;
    String company;
    String name;
    String graphicRepresentationName;
    String registrationCode;
    String economicActivity;
    String phone;
    String email;
    String direction;
    String municipality;

    Company({
        this.urlLogo = '',
        this.nit = '',
        this.dv = '',
        this.company = '',
        this.name = '',
        this.graphicRepresentationName = '',
        this.registrationCode = '',
        this.economicActivity = '',
        this.phone = '',
        this.email = '',
        this.direction = '',
        this.municipality = '',
    });

    factory Company.fromJson(Map<String, dynamic> json) => Company(
        urlLogo: json["url_logo"],
        nit: json["nit"],
        dv: json["dv"],
        company: json["company"],
        name: json["name"],
        graphicRepresentationName: json["graphic_representation_name"],
        registrationCode: json["registration_code"],
        economicActivity: json["economic_activity"],
        phone: json["phone"],
        email: json["email"],
        direction: json["direction"],
        municipality: json["municipality"],
    );

    Map<String, dynamic> toJson() => {
        "url_logo": urlLogo,
        "nit": nit,
        "dv": dv,
        "company": company,
        "name": name,
        "graphic_representation_name": graphicRepresentationName,
        "registration_code": registrationCode,
        "economic_activity": economicActivity,
        "phone": phone,
        "email": email,
        "direction": direction,
        "municipality": municipality,
    };
}