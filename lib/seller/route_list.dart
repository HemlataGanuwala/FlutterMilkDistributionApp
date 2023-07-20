import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/model/RouteModel.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/edit_route.dart';

import '../MyServices.dart';

class RouteList extends StatefulWidget{
  @override
  RouteListState createState() => RouteListState();
}

class RouteListState extends State<RouteList> {
  MyServices _myServices = MyServices();
  Future<List<RouteModel>> routefuture;
  List< RouteModel > routeList;
  List< RouteModel > searchList;

  @override
  void initState() {
    super.initState();
    routefuture = getRouteData();    
    routefuture.then((value){
      setState(() {
        searchList = routeList;
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

  Future<List<RouteModel>> getRouteData() async{
    Map<String, String> JsonBody = {
      'CompanyId':  _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Route/GetRoute"),
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
      body: Container(
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
                                      builder: (context) => EditRoute(searchList[contextIndex].Id.toString(),
                                searchList[contextIndex].RouteName,searchList[contextIndex].AgentName +" "+ searchList[contextIndex].AgentId.toString())))
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
                                    Icon(Icons.person, color: Colors.red,),
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
                                    Icon(Icons.phone, color: Colors.green,),
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
    );
  }
}