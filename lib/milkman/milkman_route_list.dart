import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/milkman/milkmancustlist.dart';
import 'package:milkdistributionflutter/model/RouteModel.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/edit_route.dart';

import '../MyServices.dart';
import '../seller/start_main_page.dart';

class MilkmanRouteList extends StatefulWidget{
  @override
  MilkmanRouteListState createState() => MilkmanRouteListState();
}

class MilkmanRouteListState extends State<MilkmanRouteList> {
  MyServices _myServices = MyServices();
  Future<List<RouteModel>> routefuture;
  List< RouteModel > pinList;
  List< RouteModel > routeList;
  List< RouteModel > searchList;
  String agentId = "";

  @override
  void initState() {
    super.initState();
    getPinData().then((value) {
      routefuture = getRouteData();    
    routefuture.then((value){
      setState(() {
        searchList = routeList;
      });
    });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<RouteModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = routeList;
    } else {
      results = routeList
          .where((user) =>
          user.RouteName.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchList = results;
    });
  }

  Future<List<RouteModel>> getPinData() async{
    Map<String, String> JsonBody = {
      'Pin':  _myServices.myMilkPin,
      'CompanyId':  _myServices.myMilkCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Agent/GetPinwiseRoute"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      pinList= List< RouteModel >.from((json.decode(response.body)['Response']).map((i) => RouteModel.fromJson(i)));
      agentId = pinList[0].Id.toString();
      return pinList;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<RouteModel>> getRouteData() async{
    Map<String, String> JsonBody = {
      'AgentId':  agentId,
      'CompanyId':  _myServices.myMilkCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Agent/GetAgentwiseRoute"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      routeList= List< RouteModel >.from((json.decode(response.body)['Response']).map((i) => RouteModel.fromJson(i)));
      return routeList;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Route List")),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Navigator.push(context, MaterialPageRoute(builder: (context) => StartMainPage()));
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextField(style: GoogleFonts.adamina(fontSize: 16.0, color: Colors.black87),
                onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    prefixIcon: Visibility(
                      child: Icon(Icons.search, color: Colors.grey,),
                    ),
                  ),),
              ),
              Container(
                child: FutureBuilder<List<RouteModel>>(
                    future: routefuture,
                  builder: (context,snapshot){
                    if (snapshot.connectionState != ConnectionState.done)
                      return Center(child: CircularProgressIndicator());
                    if(snapshot.hasData){
                      List<RouteModel> cartitem = snapshot.data;
                    }
                    return ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: searchList.length,
                        itemBuilder: (BuildContext context, int contextIndex){
                          return InkWell(
                            onTap: (){
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MilkmanCustlist(searchList[contextIndex].Id.toString(),
                                        searchList[contextIndex].AgentName,searchList[contextIndex].RouteName)))
                                .then((value) => setState(() {
                                  routefuture = getRouteData();
                                              routefuture.then((value){
                                                setState(() {
                                                  searchList = routeList;
                                                });
                                              });}));
                              // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => EditRoute(snapshot.data[contextIndex].Id.toString(),
                              //     snapshot.data[contextIndex].RouteName,snapshot.data[contextIndex].AgentName +" "+ snapshot.data[contextIndex].AgentId.toString())));
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 10.0,right: 10.0),
                                  width: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on, color: Colors.blue[700],),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(searchList[contextIndex].RouteName,
                                          style: GoogleFonts.adamina(fontSize: 16.0, color: Color(0xFF2B2B81), fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 5.0),
                                  width: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.person, color: Colors.red,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(searchList[contextIndex].AgentName,
                                          style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                    },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}