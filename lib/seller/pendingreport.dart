import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/model/PendingReportModel.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:http/http.dart' as http;

class PendingReport extends StatefulWidget {  
 
  @override
  State<StatefulWidget> createState() {
    return PendingReportState();
  }
}

class PendingReportState extends State<PendingReport> {  

  late List<PendingReportModel> pendinglist;
  late Future<List<PendingReportModel>> pendingfuture;
  MyServices _myServices = MyServices();
  int? cyear;
  String currYears = "", currmonth = "";
  double totalamt = 0, paidamt = 0, balamt = 0;

  DateTime currdt = DateTime.now();

  @override
  void initState() {
    super.initState();
    currmonth = (currdt.month-1).toString();
    currYears = (currdt.year).toString();
    pendingfuture = getPendingData();
    // dropdownYear = (cyear).toString();
  }

  Future<List<PendingReportModel>> getPendingData() async {
    Map<String, String> JsonBody = {
      'Cmonth': currmonth,
      'Cyear': currYears,
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Reports/PendingPaymentDetailReport"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      pendinglist = List<PendingReportModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => PendingReportModel.fromJson(i))); 
              setState(() {
        for (int i = 0; i < pendinglist.length; i++) {
          
          if (pendinglist[i].BalanceAmt == null) {
            pendinglist[i].BalanceAmt = "0.0";
          }
         
          balamt = balamt + double.parse(pendinglist[i].BalanceAmt!);
        }
      });     
      return pendinglist;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xFF2B2B81),
                    Colors.white54,
                  ])),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 30.0, left: 10.0),
                      alignment: Alignment.topLeft,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MainPage()));
                          },
                          child: Image.asset(
                            'assets/images/back_icon.png',
                            width: 30.0,
                            height: 30.0,
                          ))),
                  Image.asset(
                    'assets/images/milklogo.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
                    child: Text(
                      'Pending Payment Report',
                      style: GoogleFonts.aclonica(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            //List and Name
            Container(
              child: Column(
                children: <Widget>[                  
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text('Customer Name')),
                          VerticalDivider(
                            color: Colors.black,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 5,
                            child: Text('Balance'),
                          ),                          
                        ]),
                  ),
                ],
              ),
            ),
            Container(
                child: FutureBuilder<List<PendingReportModel>>(
              future: pendingfuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasData) {
                  List<PendingReportModel>? cartitem = snapshot.data;
                }
                return Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int contextIndex) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(snapshot.data![contextIndex].CustomerName
                                  .toString()),
                            ),                            
                            snapshot.data![contextIndex].BalanceAmt.toString() !=
                                    "null"
                                ? Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text(snapshot
                                        .data![contextIndex].BalanceAmt
                                        .toString()),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                  ),
                            
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                );
              },
            )),
            Divider(
              color: Colors.grey[400],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text('Total'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text(balamt.toString()),
                  ),                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
