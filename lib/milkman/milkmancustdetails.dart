import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MilkmanCustDetails extends StatefulWidget {
  String custnm,address,mobile,geolocation;
  MilkmanCustDetails(this.custnm,this.mobile,this.geolocation,this.address);
  @override
  State<StatefulWidget> createState() {
    return MilkmanCustDetailsState(custnm,mobile,geolocation,address);
  }
}

class MilkmanCustDetailsState extends State<MilkmanCustDetails> {
  String custnm,address,mobile,geolocation;
  MilkmanCustDetailsState(this.custnm,this.mobile,this.geolocation,this.address);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.7,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.0, color: Color(0xFF2B2B81)),
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  color: Color(0xFF2B2B81),
                  child: Text(
                    'Customer Details',
                    style:
                        GoogleFonts.alike(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 20.0, left: 5.0, right: 5.0, bottom: 5.0),
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Name',
                          style: GoogleFonts.alike(
                              fontSize: 14.0, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(
                          custnm,
                          style: GoogleFonts.alike(
                              fontSize: 18.0, color: Colors.green[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Mobile No.',
                          style: GoogleFonts.alike(
                              fontSize: 14.0, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          mobile,
                          style: GoogleFonts.alike(
                              fontSize: 15.0, color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Text(
                          geolocation,
                          style: GoogleFonts.alike(
                              fontSize: 14.0, color: Colors.black),
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
                  width: MediaQuery.of(context).size.width,
                  height: 80.0,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                    child: Text(
                            address,
                            maxLines: 3,
                            style: GoogleFonts.alike(
                                fontSize: 14.0, color: Colors.red),
                          ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: MediaQuery.of(context).size.width/4,
                  height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B81),
                      borderRadius: BorderRadius.circular(10),
                    ),
                   child: ButtonTheme(
                     minWidth: 150,
                     height: 40,
                     child: TextButton(
                       onPressed: (){
                        Navigator.pop(context);
                       },
                       style: TextButton.styleFrom(
                         textStyle: TextStyle(color: Colors.white,
                             backgroundColor: Color(0xFF2B2B81)),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                       ),
                       child: Text("Cancel",
                           style: GoogleFonts.adamina(fontSize: 16.0,color: Colors.white)),),
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
