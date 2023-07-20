
class PendingReportModel{
  int? Id;  
  String? CustomerName = "";
  String? BalanceAmt = "";
  double? TotalAmt;  

  PendingReportModel({this.Id,this.CustomerName,this.BalanceAmt,this.TotalAmt});

  factory PendingReportModel.fromJson(Map<String, dynamic> json) => PendingReportModel(
    Id: json['Id'],
    CustomerName: json['CustomerName'],
    TotalAmt: json['GrandTotal'],
    BalanceAmt: json['OldBalance'],        
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'GrandTotal':TotalAmt,    
    'OldBalance':BalanceAmt,
    'CustomerName': CustomerName,    
  };


}