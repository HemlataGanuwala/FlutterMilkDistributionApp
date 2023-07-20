import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:http/http.dart' as http;

class BillgeneratePopup extends StatelessWidget {
  MyServices _myServices = MyServices();
  DateTime currdt = DateTime.now();

  Future GenerateBillData() async {
    Map<String, String> JsonBody = {
      'Cmonth': (currdt.month - 1).toString(),
      'Cyear': (currdt.year).toString(),
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Bill/BillGenerate"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if (data == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Bill Generated Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);        
    } else if(data == 2){
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else if(data == 0){
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Bill Already generated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    print("DATA: ${data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 150.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 15.0),
                  child: Text(
                    'Alert Message',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Do you want generate bill?',
                    style: GoogleFonts.alike(
                        fontSize: 16.0, color: Colors.black54),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonTheme(
                        minWidth: 150,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          child: Text("No",
                              style: GoogleFonts.adamina(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 150,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            EasyLoading.show(status: "Loading.....");
                            GenerateBillData();
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Text(
                            "Yes",
                            style: GoogleFonts.adamina(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
