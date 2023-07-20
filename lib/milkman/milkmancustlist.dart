import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/milkman/milkmancustdetails.dart';
import 'package:milkdistributionflutter/model/CustomerModel.dart';
import 'package:http/http.dart' as http;

class MilkmanCustlist extends StatefulWidget {
  String routeId, routeNm,agentNm;
  MilkmanCustlist(this.routeId,this.agentNm,this.routeNm);
  @override
  State<StatefulWidget> createState() {
    return MilkmanCustListState(routeId,agentNm,routeNm);
  }
}

class MilkmanCustListState extends State<MilkmanCustlist> {
  String routeId, routeNm,agentNm;
  MilkmanCustListState(this.routeId,this.agentNm,this.routeNm);
  MyServices _myServices = MyServices();
  Future<List<CustomerModel>> customerfuture;
  List<CustomerModel> customerList = [];
  List<CustomerModel> blankList = [];
  List<CustomerModel> searchList;
  List<String> spinnerItems = [
    'Morning',
    'Evening',
  ];
  String dropdownValue = 'Morning', cDay,cMonth,cYear,cDate;
  DateTime currdt = DateTime.now();


  @override
  void initState() {
    super.initState();
    customerList = [];
    cDay = currdt.day.toString();
    cMonth = (currdt.month).toString();
    cYear = (currdt.year).toString();
    cDate = cDay+"/"+cMonth+"/"+cYear;
    customerfuture = getCustomerData();
    customerfuture.then((value){
      setState(() {
        if(customerList.length == 0){
          searchList = customerList;
        }
        else{
          searchList = customerList;
        }
        
      });
    });
  }

  Future<List<CustomerModel>> getCustomerData() async {
    Map<String, String> JsonBody = {
      'RouteId': routeId,
      'Cday': cDay,
      'Cmonth': cMonth,
      'Cyear': cYear,
      'CompanyId': _myServices.myMilkCompanyId,
      'DeliveryTime': dropdownValue,
    };
    var response = await http.post(
        Uri.parse(
            _myServices.myUrl + "Customer/GetRouteWiseDeliverytypeCustomer"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
        var data = jsonDecode(response.body)['Status'];
        var dataresponse = jsonDecode(response.body)['Response'];
    if (data != 0 && dataresponse != null) {
      customerList = List<CustomerModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => CustomerModel.fromJson(i)));
      return customerList;
    } else {
      return customerList = [];
      //throw Exception('Failed to load data from Server.');
    }
  }

  void _runFilter(String enteredKeyword) {
    List<CustomerModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = customerList;
    } else {
      results = customerList
          .where((user) => user.CustomerName.toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(agentNm +"/"+ routeNm +"/"+ cDate,
        maxLines: 2,)),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            //Search and Dropdown
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: 40.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: TextField(
                        style: GoogleFonts.adamina(
                            fontSize: 15.0, color: Colors.black87),
                        onChanged: (value) => _runFilter(value),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: dropdownValue,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 16.0),
                        underline: Container(),
                        onChanged: (String data) {
                          setState(() {
                            dropdownValue = data;
                          });
                          setState(() {
                            customerfuture = getCustomerData();
                            customerfuture.then((value) {
                              setState(() {
                                searchList = customerList;
                              });
                            });
                          });

                          // navigateToCustomerlist();
                        },
                        items: spinnerItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 16,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: Text(
                      'Customer Name',
                      style: GoogleFonts.alike(
                          fontSize: 16.0,
                          color: Color(0xFF2B2B81),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 8,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: Text(
                      'CF',
                      style: GoogleFonts.alike(
                          fontSize: 16.0,
                          color: Color(0xFF2B2B81),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 8,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: Text(
                      'CH',
                      style: GoogleFonts.alike(
                          fontSize: 16.0,
                          color: Color(0xFF2B2B81),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 8,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: Text(
                      'BF',
                      style: GoogleFonts.alike(
                          fontSize: 16.0,
                          color: Color(0xFF2B2B81),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 8,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: Text(
                      'BH',
                      style: GoogleFonts.alike(
                          fontSize: 16.0,
                          color: Color(0xFF2B2B81),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: FutureBuilder<List<CustomerModel>>(
                  future: customerfuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.hasData) {
                      List<CustomerModel> cartitem = snapshot.data;
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: searchList.length,
                        itemBuilder: (BuildContext context, int contextIndex) {
                          return InkWell(
                            onTap: () {
                              showCupertinoModalPopup(context: context, builder:
                              (context) => MilkmanCustDetails(searchList[contextIndex].CustomerName,
                              searchList[contextIndex].MobileNo, searchList[contextIndex].Geolocation,
                              searchList[contextIndex].Address));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 20,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey),
                                    ),
                                    child: Text(
                                      searchList[contextIndex].CustomerName,
                                      style: GoogleFonts.alike(
                                          fontSize: 16.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width / 8,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey),
                                    ),
                                    child: Text(
                                      searchList[contextIndex].Cowmilkqty.toString(),
                                      style: GoogleFonts.alike(
                                          fontSize: 16.0,
                                          color: Colors.black,),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width / 8,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey),
                                    ),
                                    child: Text(
                                      searchList[contextIndex].Cowmilkhalfqty.toString(),
                                      style: GoogleFonts.alike(
                                          fontSize: 16.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width / 8,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey),
                                    ),
                                    child: Text(
                                      searchList[contextIndex].Buffallomilkqty.toString(),
                                      style: GoogleFonts.alike(
                                          fontSize: 16.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width / 8,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey),
                                    ),
                                    child: Text(
                                      searchList[contextIndex].Buffallomilkhalfqty.toString(),
                                      style: GoogleFonts.alike(
                                          fontSize: 16.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
