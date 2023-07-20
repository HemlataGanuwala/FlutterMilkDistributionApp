class BillModel{
  int? Id;
  int? CustId;
  String? CustomerName;
  String? MobileNo;
  String? Cowmilk;
  String? Buffalomilk;
  int? Cowmilkqty;
  int? Cowmilkhalfqty;
  double? Cowmilkrate;
  int? Buffallomilkqty;
  int? Buffallomilkhalfqty;
  double? Buffallomilkrate;
  String? Deliverytime;
  String? Agentname;
  String? Remark;
  String? Cday;
  String? Cyear;
  String? Cmonth;
  String? CustomerStatus;
  String? Milkstatus;
  String? Oldbalance;
  String? Cdate;
  double? GrandTotal;
  String? Pin;
  String? Address;
  String? PaymentStatus;
  String? PaidAmt;
  String? PayDate;
  String? RouteName;
  String? OldBalance;  

  BillModel({this.Id,this.CustId,this.CustomerName,this.MobileNo,this.Cowmilk,
  this.Buffalomilk,this.Cowmilkqty,this.Cowmilkhalfqty,this.Cowmilkrate,this.Buffallomilkqty,
  this.Buffallomilkhalfqty,this.Buffallomilkrate,this.Deliverytime,this.Agentname,
  this.Remark,this.Cday,this.Cyear,this.Cmonth,this.CustomerStatus,this.Milkstatus,
  this.Oldbalance,this.Cdate,this.GrandTotal,this.Pin,this.Address,this.PaymentStatus,
  this.PaidAmt,this.PayDate,this.RouteName,this.OldBalance});

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
    Id: json['Id'],
    CustId: json['CustId'],
    CustomerName: json['CustomerName'],
    MobileNo: json['MobileNo'],
    Cowmilk: json['CowMilk'],
    Buffalomilk: json['BuffaloMilk'],
    Cowmilkqty: json['CowMilkQty'],
    Cowmilkhalfqty: json['CowHalfMilkQty'],
    Cowmilkrate: json['CowMilkRate'],       
    Buffallomilkqty: json['BuffalloMilkQty'],
    Buffallomilkhalfqty: json['BuffalloHalfMilkQty'],
    Buffallomilkrate: json['BuffalloMilkRate'],
    Deliverytime: json['DeliveryTime'],
    Agentname: json['AgentName'],
    Remark: json['Remark'],
    Cday: json['Cday'],
    Cyear: json['Cyear'],
    Cmonth: json['Cmonth'],
    CustomerStatus: json['CustomerStatus'],
    Milkstatus: json['Milkstatus'],
    Oldbalance: json['OldBalance'],
    Cdate: json['CDate'],
    GrandTotal: json['GrandTotal'],
    Pin: json['Pin'],
    Address: json['Address'],
    PaymentStatus: json['PaymentStatus'],
    PaidAmt: json['PaidAmt'],
    PayDate: json['PayDate'],
    RouteName: json['RouteName'],    
    OldBalance: json['OldBalance'],
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'CustId':CustId,
    'CustomerName': CustomerName,
    'MobileNo': MobileNo,
    'Address': Address,
    'PayDate':PayDate,
    'Cowmilkqty':Cowmilkqty,
    'Buffmilkqty':Buffallomilkqty,
    'Cmonth':Cmonth,
    'Cyear':Cyear,
    'GrandTotal':GrandTotal,
    'OldBalance':Oldbalance,    
    'CustomerStatus': CustomerStatus,
    'Pin': Pin,
  };


  // factory ItemModel.fromJson(Map<String, dynamic> json) {
  //
  //   String ProductName = json['ProductName'];
  //   // double ProductCost = json['ProductCost'];
  //   String ProductCost = json['ProductCost'].toString();
  //   String ProductImagePath = json['ProductImagePath'];
  //
  //   return ItemModel(
  //       ProductName,
  //       ProductCost,
  //       ProductImagePath
  //   );
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['ProductName'] = this.ProductName;
  //   data['ProductCost'] = this.Rate;
  //   data['ProductImagePath'] = this.image;
  //   return data;
  // }

}