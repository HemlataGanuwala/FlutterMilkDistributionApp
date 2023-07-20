class ProductStatusModel {
  int? Id;
  String? Product_name;
  String? Product_qty;
  double? Product_rate;
  String? Product_shortnm;
  String? Product_unit;
  String? Product_cdate;
  String? Product_status;
  String? DelvryCustmilkstatus;
  String? DelvryCustcdate;

  ProductStatusModel({this.Id, this.Product_name,this.Product_qty,this.Product_rate,this.Product_shortnm,this.Product_unit,
  this.Product_cdate,this.Product_status,this.DelvryCustcdate,this.DelvryCustmilkstatus});

  factory ProductStatusModel.fromJson(Map<String, dynamic> json) =>
      ProductStatusModel(
        Id: json['Id'],
        Product_name: json['ProductName'] ?? '',
        Product_qty: json['ProductQty']?? '',
        Product_rate: json['ProductRate']?? 0,
        Product_shortnm: json['ProductShortName']?? '',
        Product_unit: json['ProductUnit']?? '',
        Product_cdate: json['PDate']?? '',
        Product_status: json['AddProductStatus']?? '',
        DelvryCustmilkstatus: json['MilkStatus']?? '',
        DelvryCustcdate: json['CDate']?? '',
      );

  Map<String, dynamic> toJson() =>
      {
        'ProductNameId': Id,
        'ProductName': Product_name,
        'ProductQty': Product_qty,
        'ProductRate': Product_rate,
        'ProductShortName': Product_shortnm,
        'ProductUnit': Product_unit,
        'PDate': Product_cdate,
        'AddProductStatus': Product_status,
        'MilkStatus': DelvryCustmilkstatus,
        'CDate': DelvryCustcdate,
      };
}