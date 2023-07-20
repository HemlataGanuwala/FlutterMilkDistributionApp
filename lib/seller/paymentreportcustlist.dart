import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/model/RouteModel.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:milkdistributionflutter/seller/Paymentreport.dart';
import 'package:milkdistributionflutter/seller/edit_route.dart';
import 'package:milkdistributionflutter/seller/monthlyreport.dart';

import '../MyServices.dart';
import '../model/CustomerModel.dart';

class PaymentReportCustomerList extends StatefulWidget{
  @override
  PaymentReportCustomerListState createState() => PaymentReportCustomerListState();
}

class PaymentReportCustomerListState extends State<PaymentReportCustomerList> {
  MyServices _myServices = MyServices();
  Future<List<CustomerModel>> customerfuture;
  List< CustomerModel > customerList;
  List< CustomerModel > searchList;

  @override
  void initState() {
    super.initState();
    customerfuture = getCustomerData();    
    customerfuture.then((value){
      setState(() {
        searchList = customerList;
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<CustomerModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = customerList;
    } else {
      results = customerList
          .where((user) =>
          user.CustomerName.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchList = results;
    });
  }

  Future<List<CustomerModel>> getCustomerData() async{
    Map<String, String> JsonBody = {
      'CompanyId':  _myServices.myCompanyId,      
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Customer/GetCustomer"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      customerList= List< CustomerModel >.from((json.decode(response.body)['Response']).map((i) => CustomerModel.fromJson(i))).toList();
      return customerList;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Payment Customer List")),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) => MainPage())));
          return new Future(() => false);
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
                child: FutureBuilder<List<CustomerModel>>(
                    future: customerfuture,
                  builder: (context,snapshot){
                    if (snapshot.connectionState != ConnectionState.done)
                      return Center(child: CircularProgressIndicator());
                    if(snapshot.hasData){
                      List<CustomerModel> cartitem = snapshot.data;
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
                                        builder: (context) => PaymentReport(searchList[contextIndex].Id,searchList[contextIndex].CustomerName)))
                                .then((value) => setState(() {
                                  customerfuture = getCustomerData();
                                              customerfuture.then((value){
                                                setState(() {
                                                  searchList = customerList;
                                                });
                                              });}));
                              // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => EditRoute(snapshot.data[contextIndex].Id.toString(),
                              //     snapshot.data[contextIndex].RouteName,snapshot.data[contextIndex].AgentName +" "+ snapshot.data[contextIndex].AgentId.toString())));
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFF2B2B81),
                                      foregroundColor: Colors.white,
                                      child: Text(searchList[contextIndex].CustomerName.substring(0,1).toUpperCase(),
                                      style: GoogleFonts.aclonica(fontSize: 18.0),), ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 10.0,right: 10.0),
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Row(
                                          children: <Widget>[
                                            // Icon(Icons.person, color: Colors.red,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                                              child: Text(searchList[contextIndex].CustomerName,
                                                style: GoogleFonts.adamina(fontSize: 16.0, color: Color(0xFF2B2B81), fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 5.0),
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Row(
                                          children: <Widget>[
                                            // Icon(Icons.phone, color: Colors.green,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0,top: 5.0),
                                              child: Text(searchList[contextIndex].MobileNo,
                                                style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  searchList[contextIndex].CustomerStatus == "Deactive" ?
                                  Container(
                                    width: MediaQuery.of(context).size.width/5,
                                    child: Text(searchList[contextIndex].CustomerStatus,
                                    style: TextStyle(color: Colors.red, fontSize: 16.0),),
                                  ):
                                  Container(
                                    width: MediaQuery.of(context).size.width/5,
                                    
                                  ),
                                ],
                              ),
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