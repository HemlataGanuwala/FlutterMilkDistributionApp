class MilkmanModel{
  int? Id;
  String? AgentName;

  MilkmanModel({this.Id,this.AgentName});

  factory MilkmanModel.fromJson(Map<String, dynamic> json) => MilkmanModel(
    Id: json['Id'],
    AgentName: json['AgentName'],
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'AgentName': AgentName,
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