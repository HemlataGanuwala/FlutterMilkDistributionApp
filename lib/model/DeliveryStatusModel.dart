class DeliveryStatusModel{
  int? delvryid;
  int? delvryCustId;
  String? delvryCustname;
  String? delvryCustmobileno;
  String? delvryCustaddress;
  String? delvryCustcowmilk;
  String? delvryCustbuffalomilk;
  int? delvryCustcowmilkqty;
  int? delvryCustcowmilkhalfqty;
  double? delvryCustcowmilkrate;
  int? delvryCustbuffallomilkqty;
  int? delvryCustbuffallomilkhalfqty;
  double? delvryCustbuffallomilkrate;
  String? delvryCustagentname;
  int? delvryCustagentid;
  String? delvryCustroutename;
  int? delvryCustrouteid;
  String? delvryCustdeliverytime;
  String? delvryCustcday;
  String? delvryCustcyear;
  String? delvryCustcmonth;
  String? delvryCustmilkstatus;
  String? delvryoldbalance;
  String? delvryCustcdate;
  double? delvryCusttotalamt;
  String? delvryCustpin;
  double? delvrydeliverycharge;
  int? delvryreferenceno;
  String?delvrygeolocation;
  String? delvrygeocheck;

  DeliveryStatusModel({this.delvryid,this.delvryCustId,this.delvryCustname,this.delvryCustmobileno,
    this.delvryCustaddress,this.delvryCustcowmilk,this.delvryCustbuffalomilk,this.delvryCustcowmilkqty,this.delvryCustcowmilkhalfqty,this.delvryCustcowmilkrate,
    this.delvryCustbuffallomilkqty,this.delvryCustbuffallomilkhalfqty,this.delvryCustbuffallomilkrate,this.delvryCustagentname,
  this.delvryCustagentid,this.delvryCustroutename,this.delvryCustrouteid,this.delvryCustdeliverytime,this.delvryCustcday,
  this.delvryCustcyear,this.delvryCustcmonth,this.delvryCustmilkstatus,this.delvryoldbalance,this.delvryCustcdate,this.delvryCusttotalamt,this.delvryCustpin,
    this.delvrydeliverycharge,this.delvryreferenceno,this.delvrygeolocation,this.delvrygeocheck});

  factory DeliveryStatusModel.fromJson(Map<String, dynamic> json) => DeliveryStatusModel(
    delvryid: json['Id'],
    delvryCustId: json['CustId'],
    delvryCustname: json['CustomerName'],
    delvryCustmobileno: json['MobileNo'],
    delvryCustaddress: json['Address'],
    delvryCustcowmilk: json['CowMilk'],
    delvryCustbuffalomilk: json['BuffaloMilk'],
    delvryCustcowmilkqty: json['CowMilkQty'],
    delvryCustcowmilkhalfqty: json['CowHalfMilkQty'],
    delvryCustcowmilkrate: json['CowMilkRate'],
    delvryCustbuffallomilkqty: json['BuffalloMilkQty'],
    delvryCustbuffallomilkhalfqty: json['BuffalloHalfMilkQty'],
    delvryCustbuffallomilkrate: json['BuffalloMilkRate'],
    delvryCustagentname: json['AgentName'],
    delvryCustagentid: json['AgentID'],
    delvryCustroutename: json['RouteName'],
    delvryCustrouteid: json['RouteID'],
    delvryCustdeliverytime: json['DeliveryType'],
    delvryCustcday: json['Cday'],
    delvryCustcyear: json['Cyear'],
    delvryCustcmonth: json['Cmonth'],
    delvryCustmilkstatus: json['MilkStatus'],
    delvryoldbalance: json['OldBalance'],
    delvryCustcdate: json['CDate'],
    delvryCusttotalamt: json['TotalAmt'],
    delvryCustpin: json['Pin'],
    delvrydeliverycharge: json['DeliveryCharge'],
    delvryreferenceno: json['ReferenceNo'],
    delvrygeolocation: json['GeoLocation'],
    delvrygeocheck: json['GeoCheck'],
  );

  Map<String, dynamic> toJson() => {
    'Id': delvryid,
    'CustId': delvryCustId,
    'CustomerName': delvryCustname,
    'MobileNo': delvryCustmobileno,
    'Address': delvryCustaddress,
    'CowMilk': delvryCustcowmilk,
    'BuffaloMilk': delvryCustbuffalomilk,
    'CowMilkQty': delvryCustcowmilkqty,
    'CowHalfMilkQty': delvryCustcowmilkhalfqty,
    'CowMilkRate': delvryCustcowmilkrate,
    'BuffalloMilkQty': delvryCustbuffallomilkqty,
    'BuffalloHalfMilkQty': delvryCustbuffallomilkhalfqty,
    'BuffalloMilkRate': delvryCustbuffallomilkrate,
    'AgentName': delvryCustagentname,
    'AgentID': delvryCustagentid,
    'RouteName': delvryCustroutename,
    'RouteID': delvryCustrouteid,
    'DeliveryType': delvryCustdeliverytime,
    'Cday': delvryCustcday,
    'Cyear': delvryCustcyear,
    'Cmonth': delvryCustcmonth,
    'MilkStatus': delvryCustmilkstatus,
    'OldBalance': delvryoldbalance,
    'CDate': delvryCustcdate,
    'TotalAmt': delvryCusttotalamt,
    'Pin': delvryCustpin,
    'DeliveryCharge': delvrydeliverycharge,
    'ReferenceNo': delvryreferenceno,
    'GeoLocation': delvrygeolocation,
    'GeoCheck': delvrygeocheck,
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