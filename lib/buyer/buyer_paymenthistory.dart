import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/model/BillModel.dart';
import 'package:http/http.dart' as http;
import '../MyServices.dart';

class BuyerPaymentHistory extends StatefulWidget {
  final String custid;
  BuyerPaymentHistory(this.custid);
  @override
  State<StatefulWidget> createState() {
    return BuyerPaymentHistoryState(custid);
  }
}

class BuyerPaymentHistoryState extends State<BuyerPaymentHistory> {
  String custid, custnm, mobile;
  BuyerPaymentHistoryState(this.custid);

  MyServices _myServices = MyServices();
  Future<List<BillModel>> billfuture;
  List<BillModel> billList;
  bool loading = false;

  String cowmilk = "", buffmilk = "", oldbal = "", cmonth = "", cyear = "";
  int coneqty = 0, chalfqty = 0, boneqty = 0, bhalfqty = 0;
  double totamt = 0;

  TextEditingController _custname = TextEditingController();
  TextEditingController _mobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    _custname.text = custnm;
    _mobile.text = mobile;
    billfuture = getBillData();
  }

  Future<List<BillModel>> getBillData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myBuyerCompanyId,
      'CustId': custid.toString(),
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Bill/AdminPaymenthistory"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      billList = List<BillModel>.from((json.decode(response.body)['Response'])
          .map((i) => BillModel.fromJson(i))).toList();
      if (billList[0].PayDate == null) {
        billList[0].PayDate = "";
      }
      if (billList[0].Cmonth == null) {
        billList[0].Cmonth = "";
      }
      if (billList[0].PaidAmt == null) {
        billList[0].PaidAmt = "";
      }
      return billList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Payment History")),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, top: 10.0),
                  child: Image.asset(
                    'assets/images/milklogo.png',
                    height: 50.0,
                    width: 50.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                  ),
                  child: Text(
                    'Milk Dairy',
                    style: GoogleFonts.alata(
                      fontSize: 30.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.red[800],
              thickness: 2,
            ),
            
            Container(              
              child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey)),
                      child: Text(
                        'Date',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.indigo[800],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey)),
                      child: Text(
                        'Month',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.indigo[800],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 3,
                      height: 30.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey)),
                      child: Text(
                        'Amount',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.indigo[800],
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
            ),
            Container(
              child: FutureBuilder<List<BillModel>>(
                  future: billfuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.hasData) {
                      List<BillModel> cartitem = snapshot.data;
                    }
                    return ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: billList.length,
                      itemBuilder: (BuildContext context, int contextIndex) {
                        return Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey[300])),
                                child: Text(
                                  snapshot.data[contextIndex].PayDate,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey[300])),
                                child: Text(
                                  snapshot.data[contextIndex].Cmonth,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey[300])),
                                child: Text(
                                  snapshot.data[contextIndex].PaidAmt,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              )
                            ]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
