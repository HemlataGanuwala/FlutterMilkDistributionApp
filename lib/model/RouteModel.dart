class RouteModel{
  int? Id;
  String? RouteName;
  String? AgentName;
  int? AgentId;

  RouteModel({this.Id,this.RouteName,this.AgentName,this.AgentId});

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
    Id: json['Id'],
    RouteName: json['RouteName'],
    AgentName: json['AgentName'],
    AgentId: json['AgentId'],
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'RouteName':RouteName,
    'AgentName': AgentName,
    'AgentId': AgentId,

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