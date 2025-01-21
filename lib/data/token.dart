class Token {
  Token({
    DateTime? dateTime,
    required this.token_type,
    required this.expires_in,
    required this.access_token,
    required this.refresh_token,
  })  : dateTime = dateTime ?? DateTime.now(),
        id_key = 0;

  int id_key;
  DateTime dateTime;
  String token_type;
  int expires_in;
  String access_token;
  String refresh_token;

  String get acessToken => access_token;
  String get refreshToken => refresh_token;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        dateTime: DateTime.now(),
        token_type: json["token_type"],
        expires_in: json["expires_in"],
        access_token: json["access_token"],
        refresh_token: json["refresh_token"],
      );

  bool isExpired() {
    final now = DateTime.now();
    final expiration = dateTime.add(Duration(seconds: expires_in));
    return now.isAfter(expiration);
  }

  Map<String, dynamic> toMap() => {
        "id_key": id_key,
        "dateTime": dateTime.toIso8601String(),
        "token_type": token_type,
        "expires_in": expires_in,
        "access_token": access_token,
        "refresh_token": refresh_token,
  };

  @override
  String toString() {
    return 'Token: {date_time: $dateTime token_type: $token_type, expires_in: $expires_in, access_token: $access_token, refresh_token: $refresh_token}';
  }
}
