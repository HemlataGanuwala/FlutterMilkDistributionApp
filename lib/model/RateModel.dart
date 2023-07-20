class RateModel{
  int? Id;
  String? Cowrate;
  String? Buffallorate;

  RateModel({this.Id,this.Cowrate,this.Buffallorate});

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
    Id: json['Id']!,
    Cowrate: json['Cowrate']!,
    Buffallorate: json['Buffallorate']!,
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'Cowrate':Cowrate,
    'Buffallorate': Buffallorate,

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