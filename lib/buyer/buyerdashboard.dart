import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/buyer/buyer_aboutus.dart';
import 'package:milkdistributionflutter/buyer/buyer_billpay.dart';
import 'package:milkdistributionflutter/buyer/buyer_paymenthistory.dart';
import 'package:milkdistributionflutter/buyer/buyercalender.dart';
import 'package:milkdistributionflutter/model/CustomerModel.dart';
import 'package:milkdistributionflutter/seller/start_main_page.dart';
import 'package:http/http.dart' as http;


class BuyerDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuyerDashboardState();
  }
}

class BuyerDashboardState extends State<BuyerDashboard> {
  late List<CustomerModel> customerlist = [];
  MyServices _myServices = MyServices();
  String? custnm = "", bal = "";
  int? custid,cmonth;

  Future<List<CustomerModel>> getCustomerData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myBuyerCompanyId!,
      'Pin': _myServices.myBuyerPin!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Customer/GetPinwiseCustomer"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      customerlist = List<CustomerModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => CustomerModel.fromJson(i))).toList();
      if (customerlist.length != 0) {
        setState(() {
          custnm = customerlist[0].CustomerName;
          bal = customerlist[0].Oldbalance;
          custid = customerlist[0].Id;
          cmonth = int.parse(customerlist[0].Cmonth!);
        });
      }
      return customerlist;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  void initState() {
    super.initState();
    getCustomerData();
  }

  Widget MilkStatus() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyerCalenderPage(custid)));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 5.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage("assets/images/backcard.png"),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 24.0, left: 10.0),
                  child: Text(
                    "Milk Status",
                    style: GoogleFonts.adamina(
                        color: Color(0xFF2B2B81),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(right: 6.0, top: 30.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 13,
                    child: Image(
                      image: AssetImage("assets/images/calender.png"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MonthlyBill() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyerBillPay(custid.toString())));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 5.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage("assets/images/backcard.png"),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 24.0, left: 10.0),
                  child: Text(
                    "Monthly Bill",
                    style: GoogleFonts.adamina(
                        color: Color(0xFF2B2B81),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(right: 6.0, top: 30.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 13,
                    child: Image(
                      image: AssetImage("assets/images/bill_icon.png"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget PaymentHistory() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyerPaymentHistory(custid.toString())));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 5.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage("assets/images/backcard.png"),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 24.0, left: 10.0),
                  child: Text(
                    "Payment History",
                    style: GoogleFonts.adamina(
                        color: Color(0xFF2B2B81),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(right: 6.0, top: 30.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 13,
                    child: Image(
                      image: AssetImage("assets/images/pay_history.png"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget AboutUs() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuyerAboutUs()));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 5.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage("assets/images/backcard.png"),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 24.0, left: 10.0),
                  child: Text(
                    "About Us",
                    style: GoogleFonts.adamina(
                        color: Color(0xFF2B2B81),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(right: 6.0, top: 30.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 13,
                    child: Image(
                      image: AssetImage("assets/images/about_us.png"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> redirectTo() async {
    Navigator.push(context
        MaterialPageRoute(builder: (context) {
         return StartMainPage();
       }));
    return true;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.alike(fontSize: 20.0, color: Colors.white),
        ),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: WillPopScope(
        onWillPop: redirectTo,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/cardbg.png"))),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/profilepict.png"),
                        minRadius: 40,
                        maxRadius: 65,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      child: Text(
                        custnm!,
                        style: GoogleFonts.alike(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      child: Text(
                        bal!,
                        style: GoogleFonts.alike(
                            fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12.0),
                child: Row(
                  children: <Widget>[
                    MilkStatus(),
                    MonthlyBill(),
                  ],
                ),
              ),
              //Payment History and About us
              Container(
                margin: EdgeInsets.only(left: 12.0),
                child: Row(
                  children: <Widget>[
                    PaymentHistory(),
                    AboutUs(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
