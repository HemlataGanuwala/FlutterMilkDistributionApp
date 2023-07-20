class CustomerModel{
  int? Id;
  String? CustomerName;
  String? MobileNo;
  String? Address;
  String? CustomerStatus;
  String? Pin;
  String? Cowmilk;
  String? Buffalomilk;
  int? Cowmilkqty;
  int? Cowmilkhalfqty;
  double? Cowmilkrate;
  double? Cowmilktotamt;
  int? Buffallomilkqty;
  int? Buffallomilkhalfqty;
  double? Buffallomilkrate;
  double? Buffallomilktotamt;
  String? Agentname;
  int? Agentid;
  String? Routename;
  int? Routeid;
  String? Deliverytime;
  String? Cday;
  String? Cyear;
  String? Cmonth;
  String? Milkstatus;
  String? Oldbalance;
  String? Cdate;
  double? Totalamt;
  double? Deliverycharge;
  int? Referenceno;
  String? Geolocation;
  String? Geocheck;
  String? Remark;

  CustomerModel({this.Id,this.CustomerName,this.MobileNo,this.Address,this.CustomerStatus,this.Pin,
    this.Cowmilk,this.Buffalomilk,this.Cowmilkqty,this.Cowmilkhalfqty,this.Cowmilkrate,this.Cowmilktotamt,this.Buffallomilkqty,
    this.Buffallomilkhalfqty,this.Buffallomilkrate,this.Buffallomilktotamt,this.Agentname,this.Agentid,this.Routename,this.Routeid,this.Deliverytime,
    this.Cday,this.Cyear,this.Cmonth,this.Oldbalance,this.Cdate,this.Geolocation,this.Remark});

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    Id: json['Id'],
    CustomerName: json['CustomerName'],
    MobileNo: json['MobileNo'],
    Address: json['Address'],
    CustomerStatus: json['CustomerStatus'],
    Pin: json['Pin'],
    Cowmilk: json['CowMilk'],
    Buffalomilk: json['BuffaloMilk'],
    Cowmilkqty: json['CowMilkQty'],
    Cowmilkhalfqty: json['CowHalfMilkQty'],
    Cowmilkrate: json['CowMilkRate'],
    Cowmilktotamt: json['CowMilkTotAmt'],
    Buffallomilkqty: json['BuffalloMilkQty'],
    Buffallomilkhalfqty: json['BuffalloHalfMilkQty'],
    Buffallomilkrate: json['BuffalloMilkRate'],
    Buffallomilktotamt: json['BuffalloMilkTotAmt'],
    Agentname: json['AgentName'],
    Agentid: json['AgentID'],
    Routename: json['RouteName'],
    Routeid: json['RouteID'],
    Deliverytime: json['DeliveryTime'],
    Geolocation: json['GeoLocation'],
    Oldbalance: json['OldBalance'],
    Cdate: json['CDate'],
    Cday: json['Cday'],
    Cyear: json['Cyear'],
    Cmonth: json['Cmonth'],
    Remark: json['Remark'],
    
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'CustomerName': CustomerName,
    'MobileNo': MobileNo,
    'Address': Address,
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