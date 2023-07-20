import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/model/MinkmanModel.dart';
import 'package:sizer/sizer.dart';

import '../MyServices.dart';

class EditRoute extends StatefulWidget{

  String routeid,routename,agentname;

  EditRoute(this.routeid,this.routename,this.agentname);
  @override
  State<StatefulWidget> createState() {
    return EditrouteState(this.routeid,this.routename,this.agentname);
  }
}

class EditrouteState extends State<EditRoute> {
  // String dropdownValue = 'Active';
  List<MilkmanModel> _milkman;
  String selectmilkman,id,name,routeid,routename,agentname;
  MilkmanModel selectmodel;
  Future<List<MilkmanModel>> milkmanfuture;
  List milkdata;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _routename = TextEditingController();

  MyServices _myServices = new MyServices();

  EditrouteState(this.routeid,this.routename,this.agentname);

  @override
  void initState() {
    super.initState();
    // GetMilkman();
    GetMilkmanmodel();    
    id = agentname.split(" ")[1];
    name = agentname.split(" ")[0];
    _routename.text = routename;
  }

  Future GetMilkman() async{
    Map<String, String> JsonBody = {
      'CompanyId':_myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Agent/GetAgentActive"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Response'];
    setState(() {
      milkdata = data;
    });
    print(data);

  }

  Future GetMilkmanmodel() async{
    Map<String, String> JsonBody = {
      'CompanyId':_myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Agent/GetAgentActive"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    final json = jsonDecode(response.body)['Response'];

    // _milkman = jsonDecode(response.body)['Response'];
    setState(() {
      _milkman = (json)
          .map<MilkmanModel>((item) => MilkmanModel.fromJson(item))
          .toList();
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Edit Route"),
      backgroundColor: Color(0xFF2B2B81),),
      body: Container(
        margin: EdgeInsets.only(right: 10.0,left: 10.0),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Form(
                key: _formkey,
                child: Column(
                children: <Widget>[
                  TextFormField(controller: _routename,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.adamina(
                      color: Colors.black87,
                      fontSize: 14.0,
                  ),
                    textCapitalization: TextCapitalization.words,
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return "Please enter Route Name";
                      }
                      return null;
                    },
                    onSaved: (String name){
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Route Name',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: DropdownButton<String>(
                              value: agentname,
                              hint: Text("Select Milkman"),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Color(0xFF2B2B81), fontSize: 18),
                              underline: Container(),
                              onChanged: (String data) {
                                setState(() {
                                  agentname = data;
                                  id = data.split(" ")[1];
                                  name = data.split(" ")[0];
                                });
                              },
                              items: _milkman.map((MilkmanModel list) {
                                return DropdownMenuItem<String>(
                                  value: list.AgentName + " " + list.Id.toString(),
                                  child: Text(list.AgentName),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              height: 6.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B81),
                      borderRadius: BorderRadius.circular(12),
                    ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      minWidth: 150,
                      height: 40,
                      child: TextButton(
                        onPressed: (){
                          if(_formkey.currentState.validate())
                          {
                            EasyLoading.show(status: "Loading.....");
                            EditRouteData();
                            print("Successful");
                          }else
                          {
                            print("Unsuccessfull");
                          }
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(color: Colors.white,
                              backgroundColor: Color(0xFF2B2B81)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text("EDIT",
                            style: GoogleFonts.adamina(fontSize: 16.0,color: Colors.white)),),
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



  Future EditRouteData() async{
    Map<String, String> JsonBody = {
      'Id' : routeid,
      'AgentName':name,
      'RouteName':_routename.text,
      'AgentId':id,
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Route/EditRoute"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Edit successfully"),
            duration: Duration(seconds: 3),
          ));
      name ="";
    }
    else{
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 3),
          ));
    }

    print("DATA: ${data}");
  }
}

