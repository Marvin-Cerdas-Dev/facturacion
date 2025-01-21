class NumberingRange {
  String prefix;
  int from;
  int to;
  String resolutionNumber;
  String startDate;
  String endDate;
  int months;

  NumberingRange({
    this.prefix = '',
    this.from = -1,
    this.to = -1,
    this.resolutionNumber = '',
    this.startDate = '',
    this.endDate = '',
    this.months = -1,
  });

  factory NumberingRange.fromJson(Map<String, dynamic> json) => NumberingRange(
        prefix: json["prefix"],
        from: json["from"],
        to: json["to"],
        resolutionNumber: json["resolution_number"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        months: json["months"],
      );

  Map<String, dynamic> toJson() => {
        "prefix": prefix,
        "from": from,
        "to": to,
        "resolution_number": resolutionNumber,
        "start_date": startDate,
        "end_date": endDate,
        "months": months,
      };
}
