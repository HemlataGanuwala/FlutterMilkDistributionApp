import 'dart:convert';

class Reg{
  int? id;
  String? company_name;
  String? company_id;
  String? password;
  String? email;
  int? Status;
  int? Videostatus;

  Reg({
    this.id,
    this.company_name,
    this.company_id,
    this.password,
    this.email,
    this.Status,
  });

  factory Reg.fromMap(Map<String, dynamic> json) => new Reg(
    id: json["id"],
    company_name: json["company_name"],
    company_id: json["company_id"],
    password: json["password"],
    email: json["email"],
    Status: json["Status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "company_name": company_name,
    "company_id": company_id,
    "password": password,
    "email": email,
    "Status": Status,
  };

  Reg clientFromJson(String str) {
    final jsonData = json.decode(str);
    return Reg.fromMap(jsonData);
  }

  String clientToJson(Reg data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

}

class MilkmanReg{
  int id;  
  String company_id;
  String pin;  
  int Status;  

  MilkmanReg({
    this.id,
    this.pin,
    this.company_id,    
    this.Status,
  });

  factory MilkmanReg.fromMap(Map<String, dynamic> json) => new MilkmanReg(
    id: json["id"],
    pin: json["pin"],
    company_id: json["company_id"],    
    Status: json["Status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "pin": pin,
    "company_id": company_id,    
    "Status": Status,
  };

  MilkmanReg clientFromJson(String str) {
    final jsonData = json.decode(str);
    return MilkmanReg.fromMap(jsonData);
  }

  String clientToJson(MilkmanReg data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

}

class BuyerReg{
  int id;  
  String company_id;
  String pin;  
  int Status;  

  BuyerReg({
    this.id,
    this.pin,
    this.company_id,    
    this.Status,
  });

  factory BuyerReg.fromMap(Map<String, dynamic> json) => new BuyerReg(
    id: json["id"],
    pin: json["pin"],
    company_id: json["company_id"],    
    Status: json["Status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "pin": pin,
    "company_id": company_id,    
    "Status": Status,
  };

  BuyerReg clientFromJson(String str) {
    final jsonData = json.decode(str);
    return BuyerReg.fromMap(jsonData);
  }

  String clientToJson(BuyerReg data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

}