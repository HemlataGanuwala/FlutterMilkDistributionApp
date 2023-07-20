import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:intl/intl.dart';

class CompanyProfile extends StatefulWidget{

@override
  State<StatefulWidget> createState() {
    return CompanyProfileState();
  }

}
class CompanyProfileState extends State<CompanyProfile>{
  MyServices _myServices = MyServices();
  String companynm ="",substatus="",cdate="",mobile="",email=""
  ,address="",city="",cstate="",ccountry="";
  bool _isLoading = false;

  @override
  void initState() { 
    super.initState(); 
    EasyLoading.show(status: "Loading.....");
    CompanyProfileData();  
  }

Future CompanyProfileData() async {
  
    Map<String, String> JsonBody = {      
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "CompanyRegistration/GetCompanyData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    var responsedata = jsonDecode(response.body)['Response'];
    List<dynamic> list = responsedata != null ? List.from(responsedata) : null;
    if (data == 1) {  
      EasyLoading.dismiss();
        setState(() {
          companynm = list[0]["CompanyName"];
        substatus = list[0]["SubscriptionStatus"];
        cdate = list[0]["Cdate"];
        
        var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.Z');
        var inputDate = inputFormat.parse(cdate);  

        var outputFormat = DateFormat('dd-MM-yyyy');
        cdate = outputFormat.format(inputDate);
        mobile = list[0]["CMobileno"];
        email = list[0]["CEmail"];
        address = list[0]["Address"];
        city = list[0]["City"];
        cstate = list[0]["State"];
        ccountry = list[0]["Country"];
        });
    } 

    print("DATA: ${data}");
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
        title: Center(child: Text("Company Profile",
        style: GoogleFonts.alike(fontSize: 20.0, fontWeight: FontWeight.bold),)),
        backgroundColor: Color(0xFF061743),
      ),
    body: _isLoading ? Center(child: CircularProgressIndicator()) :
     WillPopScope(
      onWillPop: () => Navigator.push(context, MaterialPageRoute(builder: ((context) => MainPage()))),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg14.png"),
                  fit: BoxFit.fill,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/4,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Text(companynm,
                    style: GoogleFonts.cousine(fontSize: 24.0,
                    fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_myServices.myCompanyId,
                    style: GoogleFonts.alike(fontSize: 18.0,
                    fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Subscription: ',
                      style: TextStyle(fontSize: 14.0),
                      ),
                      Text(substatus,
                        style: TextStyle(fontSize: 14.0, color: Colors.blueAccent),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(cdate,
                        style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Contact: ',
                      style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/1.4,
                      height: 70.0,                                    
                      child: Column(                      
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(FontAwesomeIcons.phone,size: 14.0,color: Colors.grey[600],),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(mobile),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.solidEnvelope,size: 14.0,color: Colors.grey[600],),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(email),
                                    ),
                                ],
                              ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 20.0, right: 8.0),
                      child: Text('Address: ',
                      style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Container(                    
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 150.0,                                    
                      child: Column(                      
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0,bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(FontAwesomeIcons.locationDot,size: 14.0,color: Colors.grey[600],),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(address),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.city,size: 14.0,color: Colors.grey[600],),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(city),
                                    ),
                                ],
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.locationCrosshairs,size: 14.0,color: Colors.grey[600],),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(cstate),
                                    ),
                                ],
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.mapLocationDot,size: 14.0,color: Colors.grey[600],),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(ccountry),
                                    ),
                                ],
                              ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    ),
   );
  }
  
  

}

