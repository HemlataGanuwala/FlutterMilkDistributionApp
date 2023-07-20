import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/buildInputDecoration.dart';
import 'package:milkdistributionflutter/milkman/milkmanlogin.dart';
import 'package:http/http.dart' as http;

class CheckCompanyId extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckCompanyIdState();
  }
}

class CheckCompanyIdState extends State<CheckCompanyId> {
  MyServices _myServices = MyServices();
  TextEditingController _companyid = TextEditingController();

  Future GetCompanyIdData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _companyid.text,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "CompanyRegistration/CheckCompanyId"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var responseid = jsonDecode(response.body)['Response'];
    if (data == 1) {
      if (responseid == 1) {
        _myServices.myMilkCompanyId = _companyid.text;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Company Id Matched"),
          duration: Duration(seconds: 3),
        ));
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Milkmanlogin(_companyid.text)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Worng Company Id"),
        duration: Duration(seconds: 3),
      ));
    }

    print("DATA: ${data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2B2B81),
                      Colors.white54,
                    ]),
              ),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 5,
                  child: Image.asset("assets/images/milklogo.png"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 40.0, left: 50.0, right: 50.0, bottom: 30.0),
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Color(0xFF2B2B81)),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(controller: _companyid,
                //keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.characters,
                style: GoogleFonts.alike(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "Enter Company Id"),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                color: Color(0xFF2B2B81),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ButtonTheme(
                minWidth: 150,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    GetCompanyIdData();
                  },
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        color: Colors.white,
                        backgroundColor: Color(0xFF2B2B81)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("CHECK",
                      style: GoogleFonts.adamina(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
