import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/DatabaseHelper.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/Reg.dart';
import 'package:milkdistributionflutter/milkman/milkman_route_list.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:http/http.dart' as http;

import '../seller/start_main_page.dart';

class Milkmanlogin extends StatefulWidget {
  String company_id = "";
  Milkmanlogin(this.company_id);
  @override
  State<StatefulWidget> createState() {
    return MilkmanLoginState(company_id);
  }
}

class MilkmanLoginState extends State<Milkmanlogin> {
  MyServices _myServices = MyServices();
  String company_id = "";
  MilkmanLoginState(this.company_id);
String getValue = "";
bool pin = true;
MilkmanReg _reg;

@override
  void initState() {   
    super.initState();
    getValue = "";
    
  }

  Future CheckPinData() async {
    Map<String, String> JsonBody = {
      'Pin': getValue,
      'CompanyId': company_id,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Login/GetAgentLoginData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var responseid = jsonDecode(response.body)['Response'];
    if (data == 1) {
      if (responseid == 1) {
        _reg = new MilkmanReg(company_id: company_id,pin: getValue, Status: 1);
      var result = await DatabaseHelper.db.deleteMilkman();
      await DatabaseHelper.db.createMilkman(_reg);    
      _myServices.myMilkPin = getValue;    
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MilkmanRouteList()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Worng Pin"),
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
      body: WillPopScope(
        onWillPop: () {
          return Navigator.push(context, MaterialPageRoute(builder: ((context) => StartMainPage())));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF2B2B81),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 5,
                    child: Image.asset("assets/images/milklogo.png"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Login',
                  style: GoogleFonts.aclonica(
                      fontSize: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              //Pin and BackSpace
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200.0,
                    height: 50.0,
                    alignment: Alignment.center,                  
                    margin: EdgeInsets.only(top: 20.0),
                    child: Text(getValue,
                    textAlign: TextAlign.center,                  
                    style: TextStyle(color: Colors.white, fontSize: 16.0),)
                      
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 30.0,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if(getValue.length > 1)
                        {
                          getValue = getValue.substring(0, getValue.length - 1);
      
                        }
                        else if(getValue.length <= 1){
                          getValue = "";
                        }
                        });
                        
                      },
                      child: Icon(
                        Icons.backspace,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  color: Color(0xFF2B2B81),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 81, 81, 164),
                      blurRadius: 8.0, // soften the shadow
                      spreadRadius: 1.0, //extend the shadow
                      offset: Offset(
                        1.0, // Move to right 5  horizontally
                        2.0, // Move to bottom 5 Vertically
                      ),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //Number 1,2,3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "1";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "1",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "2";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "2",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "3";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "3",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Number 4,5,6
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "4";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "4",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "5";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "5",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "6";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "6",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Number 7,8,9
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "7";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "7",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "8";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "8",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              getValue = getValue + "9";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "9",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                            setState(() {
                              getValue = getValue + "0";
                              if(getValue.length == 6){
                                CheckPinData();
                                //Navigator.push(context, MaterialPageRoute(builder: ((context) => MilkmanRouteList())));
                              }
                            });
                          },
                      child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/buttonbg.png"))),
                            child: Center(
                              child: Text(
                                "0",
                                style:
                                    TextStyle(fontSize: 16.0, color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
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
    );
  }
}
