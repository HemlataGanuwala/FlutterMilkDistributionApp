import 'dart:convert';

class MilkmanCompReg{
  int? id;
  String? milkmanpin;
  String? milkmancompany_id;
  int? milkman_status;

  MilkmanCompReg({
    this.id,
    this.milkmanpin,
    this.milkmancompany_id,
    this.milkman_status,
  });

  factory MilkmanCompReg.fromMap(Map<String, dynamic> json) => new MilkmanCompReg(
    id: json["id"],
    milkmanpin: json["milkmanpin"],
    milkmancompany_id: json["milkmancompany_id"],
    milkman_status: json["milkman_status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "milkmanpin": milkmanpin,
    "milkmancompany_id": milkmancompany_id,
    "milkman_status": milkman_status,
  };

  MilkmanCompReg clientFromJson(String str) {
    final jsonData = json.decode(str);
    return MilkmanCompReg.fromMap(jsonData);
  }

  String clientToJson(MilkmanCompReg data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

}