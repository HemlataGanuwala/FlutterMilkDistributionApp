import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/model/RouteModel.dart';
import 'package:milkdistributionflutter/seller/AddCustomer.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/customer_list.dart';

import '../MyServices.dart';

class CustomerRouteList extends StatefulWidget{
  @override
  CustomerRouteListState createState() => CustomerRouteListState();

}

class CustomerRouteListState extends State<CustomerRouteList> {

  MyServices _myServices = MyServices();
  Future<List<RouteModel>> routefuture;
  List< RouteModel > routeList;

  @override
  void initState() {
    super.initState();
    routefuture = getRouteData();
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
      appBar: AppBar(title: Text("Route List"),
      actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomer()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.person_add),
            ),
          ),
      ],
      backgroundColor: Color(0xFF2B2B81),),
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
              child: TextFormField(style: GoogleFonts.adamina(fontSize: 16.0, color: Colors.black87),
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
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int contextIndex){
                      return InkWell(
                        onTap: (){
                          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) => CustomerList(snapshot.data[contextIndex].Id.toString())));
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
                                    child: Text(snapshot.data[contextIndex].RouteName,
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
                                    child: Text(snapshot.data[contextIndex].AgentName,
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

