import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/model/CustomerModel.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/calender.dart';
import 'package:milkdistributionflutter/seller/editcustomer.dart';

class CustomerList extends StatefulWidget{
  String? routeid;
  CustomerList(this.routeid);

  @override
  CustomerListState createState() => CustomerListState(routeid!);
  
}

class CustomerListState extends State<CustomerList>{
  String routeid;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List <String> spinnerItems = [
    'Morning',
    'Evening',
  ] ;
  CustomerListState(this.routeid);
  String? dropdownValue = 'Morning';
  MyServices _myServices = new MyServices();
  late Future<List<CustomerModel>> customerfuture;
  late List< CustomerModel > customerList;
  late List< CustomerModel > searchList;

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
          user.CustomerName!.toLowerCase().contains(enteredKeyword.toLowerCase()))
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
      'DeliveryTime':  dropdownValue!,
      'RouteID':  routeid,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Customer/GetAgentCustomer"),
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
        title: Text("Customer List"),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 130.0,
              color: Color(0xFF2B2B81),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 300.0,
                    margin: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Text("Search", style: GoogleFonts.adamina(fontSize: 16.0,color: Colors.white),),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0),
                            height: 40.0,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
                              child: TextField(style: GoogleFonts.adamina(fontSize: 16.0, color: Colors.white),
                              onChanged: (value) => _runFilter(value),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 250.0,
                    margin: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Text("Time", style: GoogleFonts.adamina(fontSize: 16.0,color: Colors.white),),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0),
                            height: 40.0,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                dropdownColor: Color(0xFF2B2B81),
                                value: dropdownValue,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                                underline: Container(),
                                onChanged: (String? data) {
                                  setState(() {
                                    dropdownValue = data;
                                  });
                                  setState(() {
                                    customerfuture = getCustomerData();
                                    customerfuture.then((value){
                                      setState(() {
                                        searchList = customerList;
                                      });
                                    });
                                  });

                                  // navigateToCustomerlist();
                                },
                                items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
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
            Container(
              child: FutureBuilder<List<CustomerModel>>(
                future: customerfuture,
                builder: (context,snapshot){
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: CircularProgressIndicator());
                  if(snapshot.hasData){
                    List<CustomerModel>? cartitem = snapshot.data;
                  }
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: searchList.length,
                    itemBuilder: (BuildContext context, int contextIndex){
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalenderPage(snapshot.data![contextIndex].Id!)));
                          // snapshot.data[contextIndex].Id.toString(),
                          //     snapshot.data[contextIndex].RouteName,snapshot.data[contextIndex].AgentName +" "+ snapshot.data[contextIndex].AgentId.toString())));
                        },
                        child: Card(
                          key: UniqueKey(),
                          margin: EdgeInsets.all(10.0),
                          elevation: 10.0,
                          color: Colors.white,
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
                              height: 120.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(searchList[contextIndex].CustomerName.toString(),style: GoogleFonts.adamina(fontSize: 16.0, color: Colors.black54, fontWeight: FontWeight.bold),),
                                      Spacer(),
                                      Text(searchList[contextIndex].MobileNo.toString(),style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black54),),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                    child: Text(searchList[contextIndex].Address.toString(),style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black54,),
                                    textAlign: TextAlign.left,),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text("Pin : ",style: GoogleFonts.adamina(fontSize: 14.0, color: Color(0xFF2B2B81), fontWeight: FontWeight.bold),),
                                        Padding(
                                          padding: const EdgeInsets.only(left : 8.0),
                                          child: Text(searchList[contextIndex].Pin.toString(),style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.red),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCustomer(searchList[contextIndex].Id!)));
                                    },
                                    child: Text("Edit",style: GoogleFonts.adamina(fontSize: 16.0, color: Color(0xFF2B2B81)),)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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