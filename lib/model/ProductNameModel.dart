class ProductNameModel {
  int? Id;
  String? Product_name;

  ProductNameModel({this.Id, this.Product_name});

  factory ProductNameModel.fromJson(Map<String, dynamic> json) =>
      ProductNameModel(
        Id: json['ProductNameId'],
        Product_name: json['ProductName'],
      );

  Map<String, dynamic> toJson() =>
      {
        'ProductNameId': Id,
        'ProductName': Product_name,
      };
}