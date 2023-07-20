import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/model/BillModel.dart';
import 'package:milkdistributionflutter/model/CustomerModel.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/billpay.dart';


class BillPayCustomerList extends StatefulWidget{
 @override
  State<StatefulWidget> createState() {
    return BillPayCustomerListState();
  }

}

class BillPayCustomerListState extends State<BillPayCustomerList> {
MyServices _myServices = MyServices();
  Future<List<BillModel>>? customerfuture;
  List< BillModel >? customerList;
  List< BillModel >? searchList;

@override
  void initState() {
    super.initState();
    customerfuture = getCustomerData();    
    customerfuture!.then((value){
      setState(() {
        searchList = customerList;
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<BillModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = customerList!;
    } else {
      results = customerList!
          .where((user) =>
          user.CustomerName!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchList = results;
    });
  }

  Future<List<BillModel>> getCustomerData() async{
    Map<String, String> JsonBody = {
      'CompanyId':  _myServices.myCompanyId!,      
    };
    var response = await http.post(Uri.parse(_myServices.myUrl! + "Bill/GetBillCustomer"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      customerList= List< BillModel >.from((json.decode(response.body)['Response']).map((i) => BillModel.fromJson(i))).toList();
      return customerList!;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Billing Customer List")),
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
              child: FutureBuilder<List<BillModel>>(
                  future: customerfuture,
                builder: (context,snapshot){
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: CircularProgressIndicator());
                  if(snapshot.hasData){
                    List<BillModel>? cartitem = snapshot.data;
                  }
                  return ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: searchList!.length,
                      itemBuilder: (BuildContext context, int contextIndex){
                        return InkWell(
                          onTap: (){
                            // Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => EditRoute(searchList[contextIndex].Id.toString(),
                            //               searchList[contextIndex].RouteName,searchList[contextIndex].AgentName +" "+ searchList[contextIndex].AgentId.toString())))
                            //             .then((value) => setState(() {
                            //               routefuture = getRouteData();
                            //                 routefuture.then((value){
                            //                   setState(() {
                            //                     searchList = routeList;
                            //                   });
                            //                 });
                            //               }));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BillPay(searchList![contextIndex].CustId.toString())));
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
                                      child: Text(searchList![contextIndex].CustomerName!,
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
                                    Icon(Icons.add_location, color: Colors.green,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(searchList![contextIndex].Address!,
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