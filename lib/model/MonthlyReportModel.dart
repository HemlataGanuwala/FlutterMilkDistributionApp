class MonthlyReportModel{
  int? Id;
  int? Buff_full;
  int? Buff_half;
  int? Cow_full;
  int? Cow_half;
  String? CustDate;
  String? Product = "";

  MonthlyReportModel({this.Id,this.Buff_full,this.Buff_half,this.Cow_full,this.Cow_half,
  this.CustDate,this.Product});

  factory MonthlyReportModel.fromJson(Map<String, dynamic> json) => MonthlyReportModel(
    Id: json['Id'],
    Buff_full: json['BuffalloMilkQty'],
    Buff_half: json['BuffalloHalfMilkQty'],
    Cow_full: json['CowMilkQty'],
    Cow_half: json['CowHalfMilkQty'],
    CustDate: json['CDate'],
    Product: json['ProductStatus'],
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'BuffalloMilkQty':Buff_full,
    'BuffalloHalfMilkQty': Buff_half,
    'CowMilkQty':Cow_full,
    'CowHalfMilkQty': Cow_half,
    'CDate': CustDate,
    'ProductStatus': Product,

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