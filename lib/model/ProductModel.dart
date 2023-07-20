class ProductModel {
  int? Id;
  String? Product_name;
  String? Product_qty;
  double? Product_rate;
  String? Product_shortnm;
  String? Product_unit;
  int? Product_Name_Id;

  ProductModel({this.Id, this.Product_name,this.Product_qty,this.Product_rate,this.Product_shortnm,this.Product_unit,
  this.Product_Name_Id});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel(
        Id: json['Id'],
        Product_name: json['ProductName'],
        Product_qty: json['ProductQty'],
        Product_rate: json['ProductRate'],
        Product_shortnm: json['ProductShortName'],
        Product_unit: json['ProductUnit'],
        Product_Name_Id: json['ProductNameId'],
      );

  Map<String, dynamic> toJson() =>
      {
        'ProductNameId': Id,
        'ProductName': Product_name,
        'ProductQty': Product_qty,
        'ProductRate': Product_rate,
        'ProductShortName': Product_shortnm,
        'ProductUnit': Product_unit,
        'ProductNameId': Product_Name_Id,
      };
}