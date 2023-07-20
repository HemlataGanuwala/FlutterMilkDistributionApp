import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/common/AppContainer.dart';
import 'package:milkdistributionflutter/model/MonthlyReportModel.dart';
import 'package:milkdistributionflutter/model/PaymentReportModel.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkdistributionflutter/seller/monthlycustlist.dart';
import 'package:milkdistributionflutter/seller/paymentreportcustlist.dart';

class PaymentReport extends StatefulWidget {
  int custid;
  String custname;

  PaymentReport(this.custid,this.custname);

  @override
  State<StatefulWidget> createState() {
    return PaymentReportState(custid,custname);
  }
}

class PaymentReportState extends State<PaymentReport> {
  int? custid;
  String? custname;
  PaymentReportState(this.custid,this.custname);

  late List<PaymentReportModel> paymentlist;
  late Future<List<PaymentReportModel>> paymentfuture;
  MyServices _myServices = MyServices();
  int? cyear;
  String addYears = "", currmonth = "";
  double totalamt = 0, paidamt = 0, balamt = 0;

  DateTime currdt = DateTime.now();

  @override
  void initState() {
    super.initState();
    paymentfuture = getPaymentData();
    // dropdownYear = (cyear).toString();
  }

  Future<List<PaymentReportModel>> getPaymentData() async {
    Map<String, String> JsonBody = {
      'CustId': custid.toString(),
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Reports/PaymentDetailReport"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      paymentlist = List<PaymentReportModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => PaymentReportModel.fromJson(i)));

      setState(() {
        for (int i = 0; i < paymentlist.length; i++) {
          if (paymentlist[i].PaidAmt == null) {
            paymentlist[i].PaidAmt = "0.0";
          }
          if (paymentlist[i].BalanceAmt == null) {
            paymentlist[i].BalanceAmt = "0.0";
          }
          totalamt = totalamt + paymentlist[i].TotalAmt!;
          paidamt = paidamt + double.parse(paymentlist[i].PaidAmt!);
          balamt = balamt + double.parse(paymentlist[i].BalanceAmt!);
        }
      });
      return paymentlist;
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
                                        PaymentReportCustomerList()));
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
                      'Payment Report',
                      style: GoogleFonts.aclonica(
                        fontSize: 30.0,
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
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      custname.toString(),
                      style: GoogleFonts.aclonica(
                          fontSize: 20.0, color: Colors.black),
                    ),
                  ),
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
                              width: MediaQuery.of(context).size.width / 5,
                              child: Text('Month')),
                          VerticalDivider(
                            color: Colors.black,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 5,
                            child: Text('Total'),
                          ),
                          VerticalDivider(
                            color: Colors.black,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 5,
                            child: Text('Paid'),
                          ),
                          VerticalDivider(
                            color: Colors.black,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 5,
                            child: Text('Balance'),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            Container(
                child: FutureBuilder<List<PaymentReportModel>>(
              future: paymentfuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasData) {
                  List<PaymentReportModel>? cartitem = snapshot.data;
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
                              width: MediaQuery.of(context).size.width / 5,
                              child: Text(snapshot.data![contextIndex].CMonth
                                  .toString()),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 5,
                              child: Text(snapshot.data![contextIndex].TotalAmt
                                  .toString()),
                            ),
                            snapshot.data![contextIndex].PaidAmt.toString() !=
                                    "null"
                                ? Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text(snapshot
                                        .data![contextIndex].PaidAmt
                                        .toString()),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 5,
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
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('Total'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text(totalamt.toString()),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text(paidamt.toString()),
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
