import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Reg.dart';

class DatabaseHelper{
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();
  late Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "MilkDistributionDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE CompanyRegistration ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "company_name TEXT,"
          "company_id TEXT,"
          "password TEXT,"
          "email TEXT,"
          "Status int"
          ")");

      await db.execute("CREATE TABLE MilkmanRegistration ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "pin TEXT,"
          "company_id TEXT,"          
          "Status int"
          ")");    

      await db.execute("CREATE TABLE BuyerRegistration ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "pin TEXT,"
          "company_id TEXT,"          
          "Status int"
          ")");        
    });
  }

  Future<int> createCustomer(Reg customer) async {
    final db = await database;
    var result = await db.insert("CompanyRegistration", customer.toMap());
    return result;
  }

  Future<int> createMilkman(MilkmanReg milkman) async {
    final db = await database;
    var result = await db.insert("MilkmanRegistration", milkman.toMap());
    return result;
  }

  Future<int> createBuyer(BuyerReg milkman) async {
    final db = await database;
    var result = await db.insert("BuyerRegistration", milkman.toMap());
    return result;
  }

  // newClient(Reg newClient) async {
  //   final db = await database;
  //   var res = await db.rawInsert(
  //       "INSERT Into Customer (first_name,mobileno,image,email,Status)"
  //           " VALUES (${newClient.firstName},${newClient.mobileno},${newClient.image},${newClient.email},${newClient.Status})");
  //   return res;
  // }

  Future<List> getCustomers() async {
    final db = await database;
    var result = await db.query("CompanyRegistration", columns: ["id", "company_name", "company_id", "password","email","Status"]);

    return result.toList();
  }

  Future<List> getMilkman() async {
    final db = await database;
    var result = await db.query("MilkmanRegistration", columns: ["id", "pin", "company_id","Status"]);

    return result.toList();
  }

  Future<List> getBuyer() async {
    final db = await database;
    var result = await db.query("BuyerRegistration", columns: ["id", "pin", "company_id","Status"]);

    return result.toList();
  }

  Future<List<Reg>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('CompanyRegistration');

    // Convert the List<Map<String, dynamic> into a List<Recipe>.
    return List.generate(maps.length, (i) {
      return Reg(
        id: maps[i]['id'],
        company_name: maps[i]['company_name'],
        company_id: maps[i]['company_id'],
        password: maps[i]['password'],
        email: maps[i]['email'],
        Status: maps[i]['Status'],
        // Same for the other properties
      );
    });
  }

  Future<List<MilkmanReg>> getAllMilkman() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('MilkmanRegistration');

    // Convert the List<Map<String, dynamic> into a List<Recipe>.
    return List.generate(maps.length, (i) {
      return MilkmanReg(
        id: maps[i]['id'],
        pin: maps[i]['pin'],
        company_id: maps[i]['company_id'],        
        Status: maps[i]['Status'],
        // Same for the other properties
      );
    });
  }

  Future<List<BuyerReg>> getAllBuyer() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('BuyerRegistration');

    // Convert the List<Map<String, dynamic> into a List<Recipe>.
    return List.generate(maps.length, (i) {
      return BuyerReg(
        id: maps[i]['id'],
        pin: maps[i]['pin'],
        company_id: maps[i]['company_id'],        
        Status: maps[i]['Status'],
        // Same for the other properties
      );
    });
  }

  // Future<int> updateCustomer(Reg customer) async {
  //   final db = await database;
  //   return await db.rawUpdate(
  //       'UPDATE Customer SET Status = ${customer.Status} WHERE email = ${customer.email}'
  //   );
  // }

  Future<int> updateCustomer(Reg customer) async {
    final db = await database;
    return await db.update("CompanyRegistration", customer.toMap(), where: "email = ?", whereArgs: [customer.email]);
  }

  Future<int> deleteCustomer() async {
    final db = await database;
    return await db.delete("CompanyRegistration");
  }

  Future<int> deleteMilkman() async {
    final db = await database;
    return await db.delete("MilkmanRegistration");
  }

  Future<int> deleteBuyer() async {
    final db = await database;
    return await db.delete("BuyerRegistration");
  }

  // deleteAllPersons()async{
  //   final db = await database;
  //   db.delete("person");
  // }
  // updatePerson(Person person)async{
  //   final db = await database;
  //   var result = db.update("Person", person.toMap(),where: "id=?",whereArgs: [person.id]);
  //   print('$result');
  //   return result;
  //
  // }

}



