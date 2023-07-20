class PaymentReportModel{
  int? Id;
  double? TotalAmt;
  String? PaidAmt = "";
  String? BalanceAmt = "";
  String? CMonth;  

  PaymentReportModel({this.Id,this.TotalAmt,this.PaidAmt,this.BalanceAmt,this.CMonth});

  factory PaymentReportModel.fromJson(Map<String, dynamic> json) => PaymentReportModel(
    Id: json['Id'],
    TotalAmt: json['GrandTotal'],
    PaidAmt: json['PaidAmt'],
    BalanceAmt: json['OldBalance'],
    CMonth: json['Cmonth'],    
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'GrandTotal':TotalAmt,
    'PaidAmt': PaidAmt,
    'OldBalance':BalanceAmt,
    'Cmonth': CMonth,    
  };


}