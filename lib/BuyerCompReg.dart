import 'dart:convert';

class BuyerCompReg{
  int id;
  String pin;
  String buyer_company_id;
  int buyer_status;

  BuyerCompReg({
    this.id,
    this.pin,
    this.buyer_company_id,
    this.buyer_status,
  });

  factory BuyerCompReg.fromMap(Map<String, dynamic> json) => new BuyerCompReg(
    id: json["id"],
    pin: json["pin"],
    buyer_company_id: json["buyer_company_id"],
    buyer_status: json["buyer_status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "pin": pin,
    "buyer_company_id": buyer_company_id,
    "buyer_status": buyer_status,
  };

  BuyerCompReg clientFromJson(String str) {
    final jsonData = json.decode(str);
    return BuyerCompReg.fromMap(jsonData);
  }

  String clientToJson(BuyerCompReg data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

}