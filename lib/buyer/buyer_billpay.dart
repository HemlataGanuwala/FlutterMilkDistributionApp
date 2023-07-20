import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../MyServices.dart';

class BuyerBillPay extends StatefulWidget {
  final String custid;
  BuyerBillPay(this.custid);
  @override
  State<StatefulWidget> createState() {
    return BuyerBillPayState(custid);
  }
}

class BuyerBillPayState extends State<BuyerBillPay> {
  String custid;
  BuyerBillPayState(this.custid);

  MyServices _myServices = MyServices();  
  bool loading = false;

  String cowmilk = "", buffmilk = "", oldbal = "", cmonth = "", cyear = "",
  _paidamt="",_custname = "",_receipt="",_billdt = "",_mobile="",_address = "",
  _month="",_year = "",_cowliter="",_buffliter = "";
  int coneqty = 0, chalfqty = 0, boneqty = 0, bhalfqty = 0;
  double totamt = 0;  

  DateTime currdt = DateTime.now();

  @override
  void initState() {
    super.initState();
    cmonth = (currdt.month - 1).toString();
    var prevMonth = new DateTime(currdt.year, currdt.month - 1, currdt.day);
    cmonth = DateFormat("MMMM").format(prevMonth).toString();
    cyear = (currdt.year).toString();
    getBillData(); 
       
  }

  Future getBillData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myBuyerCompanyId,
      'Pin': _myServices.myBuyerPin,
      'Cmonth': cmonth,
      'Cyear': cyear,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Bill/BillFormateData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
        var data = jsonDecode(response.body)['Status'];
    var responsedata = jsonDecode(response.body)['Response'];
    if (data == 1) {
      setState(() {
        _receipt = responsedata[0]["Id"].toString();
        _billdt = responsedata[0]["CDate"];
        _custname = responsedata[0]["CustomerName"];
        _mobile = responsedata[0]["MobileNo"];
        _address = responsedata[0]["Address"];
        _month = responsedata[0]["Cmonth"];
        _year = responsedata[0]["Cyear"];
        totamt = responsedata[0]["GrandTotal"];
        _paidamt = responsedata[0]["Cyear"];
        cowmilk = responsedata[0]["CowMilk"];
        cowmilk = "Cow";
        buffmilk = responsedata[0]["BuffaloMilk"];
        buffmilk = "Buff";
          coneqty = responsedata[0]["CowMilkQty"];
        chalfqty = responsedata[0]["CowHalfMilkQty"];
        _cowliter = (coneqty + chalfqty * 0.5).toString();
        
        boneqty = responsedata[0]["BuffalloMilkQty"];
        bhalfqty = responsedata[0]["BuffalloHalfMilkQty"];
        _buffliter = (boneqty + bhalfqty * 0.5).toString();
      });

    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Bill")),
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
            //Bill Section
            Container(
              margin: EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: Colors.blue[800])),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Monthly Bill',
                      style: GoogleFonts.aclonica(
                        fontSize: 24.0,
                        color: Colors.transparent,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.double,
                        decorationColor: Colors.red,
                        decorationThickness: 5,
                        shadows: [
                          Shadow(
                              color: Colors.green[800], offset: Offset(0, -10))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 5.0),
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Receipt No.:',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.indigo[800],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 70.0,
                            child: Text(
                              _receipt ?? "",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,                              
                            ),
                          ),
                          Text(
                            'Bill Date:',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.indigo[800],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 100.0,
                            child: Text(
                              _billdt ?? "",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,                              
                            ),
                          )
                        ]),
                  ),

                  Container(
                      //alignment: Alignment.center,
                      //margin: EdgeInsets.only(left: 20.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                //Name
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Name:',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.red[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 160.0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            _custname ?? "",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[600],
                                            ),
                                            
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Mobile
                                Container(
                                  margin: EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Mobile No.:',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.red[800],
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 160.0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                             _mobile ?? "",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[600],
                                            ),
                                            
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Address
                                Container(
                                  margin: EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Address:',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.red[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 185.0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            _address ?? "",
                                            maxLines: null,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[600],
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
                              width: 90.0,                              
                              child: Column(
                                children: <Widget>[
                                  Row(                                     
                                      children: [
                                        Text(
                                          cowmilk ?? "" + ":",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.indigo[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                          child: Text(
                                           _cowliter,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[600],
                                            ),                                            
                                          ),
                                        ),
                                      ]),
                                  Row(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          buffmilk ?? "" + ":",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.indigo[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 40.0,
                                          child: Text(
                                            _cowliter,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[600],
                                            ),
                                            
                                          ),
                                        ),
                                      ]),
                                ],
                              )),
                        ],
                      )),
                  //Month and Year
                  Container(
                    margin: EdgeInsets.only(left: 30.0),
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Month:',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.indigo[800],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 100.0,
                            child: Text(
                              _month ?? "",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                              
                            ),
                          ),
                          Text(
                            'Year:',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.indigo[800],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 100.0,
                            child: Text(
                              _year ?? "",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                              
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.red[800],
              thickness: 2,
            ),
            //Total Amount
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 150.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 2.0, color: Color(0xFF2B2B81)),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Text(
                        totamt.toString() ?? "0.0",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            ),            
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Paid Amount:',                    
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 150.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 2.0, color: Color(0xFF2B2B81)),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Text(_paidamt ?? "0.0",                                                
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            ),
            
          ],
        ),
      ),
    );
  }
}
