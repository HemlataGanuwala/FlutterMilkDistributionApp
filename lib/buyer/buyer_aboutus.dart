import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:http/http.dart' as http;

class BuyerAboutUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuyerAboutUsState();
  }
}

class BuyerAboutUsState extends State<BuyerAboutUs> {
  MyServices _myServices = MyServices();
  String address, mobile, email, companynm;

  @override
  void initState() {
    super.initState();
    GetCompanyData();
  }

  Future GetCompanyData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myBuyerCompanyId,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "CompanyRegistration/GetCompanyData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var responsedata = jsonDecode(response.body)['Response'];
    if (data == 1) {
      setState(() {
        companynm = responsedata[0]["CompanyName"];
        address = responsedata[0]["Address"];
        email = responsedata[0]["CEmail"];
        mobile = responsedata[0]["CMobileno"];
      });
    }
    print("DATA: ${data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("About Us")),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 9,
                child: Text(
                  companynm ?? "",
                  style: GoogleFonts.aclonica(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B81)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8.0),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Address",
                style:
                    GoogleFonts.alike(fontSize: 16.0, color: Color(0xFF2B2B81)),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Color(0xFF2B2B81)),
                  borderRadius: BorderRadius.circular(6.0)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 24.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      address ?? "",
                      maxLines: 2,
                      style: GoogleFonts.alike(fontSize: 16.0),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 8.0),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Contact Info",
                style:
                    GoogleFonts.alike(fontSize: 16.0, color: Color(0xFF2B2B81)),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Color(0xFF2B2B81)),
                  borderRadius: BorderRadius.circular(6.0)),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.phone,
                            size: 20.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mobile ?? "",
                            maxLines: 2,
                            style: GoogleFonts.alike(fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.email,
                            size: 20.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            email ?? "",
                            maxLines: 2,
                            style: GoogleFonts.alike(fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
