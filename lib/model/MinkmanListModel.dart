class MilkmanListModel{
  int? Id;
  String? AgentName;
  String? MobileNo;
  String? MobileNo1;
  String? Emailid;
  String? Route;
  String? AgentStatus;
  String? Pin;
  String? WhatsappNo1;
  String? WhatsappNo2;
  String? CompanyId;

  MilkmanListModel({this.Id,this.AgentName,this.MobileNo,this.MobileNo1,this.Emailid
  ,this.Route,this.AgentStatus,this.Pin,this.WhatsappNo1,this.WhatsappNo2,this.CompanyId});

  factory MilkmanListModel.fromJson(Map<String, dynamic> json) => MilkmanListModel(
    Id: json['Id'],
    AgentName: json['AgentName'] ?? "",
    MobileNo: json['MobileNo'] ?? "",
    MobileNo1: json['MobileNo1'] ?? "",
    Emailid: json['Emailid'] ?? "",
    Route: json['Route'] ?? "",
    AgentStatus: json['AgentStatus'] ?? "",
    Pin: json['Pin'] ?? "",
    WhatsappNo1: json['WhatsappNo1'] ?? "",
    WhatsappNo2: json['WhatsappNo2'] ?? "",
    CompanyId: json['CompanyId'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'AgentName': AgentName,
    'MobileNo' : MobileNo,
    'MobileNo1' : MobileNo1,
    'Emailid' : Emailid,
    'Route' : Route,
    'AgentStatus' : AgentStatus,
    'Pin' : Pin,
    'WhatsappNo1' : WhatsappNo1,
    'WhatsappNo2' : WhatsappNo2,
    'CompanyId' : CompanyId,
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