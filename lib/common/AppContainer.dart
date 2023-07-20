import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/model/Navigation_model.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:milkdistributionflutter/seller/add_milkman.dart';
import 'package:milkdistributionflutter/seller/add_products.dart';
import 'package:milkdistributionflutter/seller/add_route.dart';
import 'package:milkdistributionflutter/seller/billnotgenerate.dart';
import 'package:milkdistributionflutter/seller/billpaycustomerlist.dart';
import 'package:milkdistributionflutter/seller/companyprofile.dart';
import 'package:milkdistributionflutter/seller/customerroute_list.dart';
import 'package:milkdistributionflutter/seller/helppage.dart';
import 'package:milkdistributionflutter/seller/monthlycustlist.dart';
import 'package:milkdistributionflutter/seller/monthlyreport.dart';
import 'package:milkdistributionflutter/seller/paymenthistorylist.dart';
import 'package:milkdistributionflutter/seller/paymentreportcustlist.dart';
import 'package:milkdistributionflutter/seller/pendingreport.dart';
import 'package:milkdistributionflutter/seller/start_main_page.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../seller/bill_generate_popup.dart';

class AppContainer extends StatefulWidget {
  @override
  AppContainerState createState() => AppContainerState();
}

class AppContainerState extends State<AppContainer> {
  bool sidebaropen = false;

  double yoffset = 0;
  double xoffset = 50;
  bool loading = false;

  void setsidebarstate() {
    setState(() {
      xoffset = sidebaropen ? 50 : 50;
    });
  }

  MyServices _myservices = new MyServices();
  DateTime currdt = DateTime.now();
  String cmonth = "", cyear = "";

  @override
  void initState() {
    super.initState();
    DateTime currdt = DateTime.now();
    var prevMonth = new DateTime(currdt.year, currdt.month - 1, currdt.day);
    cmonth = DateFormat("MMMM").format(prevMonth).toString();
    cyear = (currdt.year).toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(color: Color(0xFF2B2B81), child: MainContainer()),
    );
  }

  Future BillGenerateData() async {
    
    Map<String, String> JsonBody = {
      'Cmonth': cmonth,
      'Cyear': cyear,
      'CompanyId': _myservices.myCompanyId,
    };
    var response = await http.post(
        Uri.parse(_myservices.myUrl + "Bill/BillNotGenetaredData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var responsebill = jsonDecode(response.body)['Response'];
    var message = jsonDecode(response.body)['Message'];
    if (responsebill == 0) {
      loading = false;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => BillNotGenerate()));
    } else {
      loading = false;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BillPayCustomerList()));
    }

    print("DATA: ${data}");
  }

  Widget loadingindicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget MainContainer() {
    return Stack(
      children: <Widget>[
        Container(
          // width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 15.0, top: 8.0, left: 4.0),
                child: Container(
                  margin: EdgeInsets.only(top: 7.0.h),
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height / 18,
                  child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StartMainPage()));
                        // Navigator.pop(context);
                      },
                      child: Image(
                        image: AssetImage("assets/images/back_icon.png"),
                      )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 15.0, top: 8.0, left: 8.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height / 22,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompanyProfile()));
                    },
                    child: Image(
                      image: AssetImage("assets/images/icon_profile.png"),
                    ),
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                      itemCount: navigationItems.length,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              sidebaropen = false;
                              setsidebarstate();
                            },
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  new RotatedBox(
                                    quarterTurns: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 8.0, left: 40.0),
                                      child: InkWell(
                                        onTap: () {
                                          if(navigationItems[index].title == "Monthly")
                                          {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MonthlyCustomerList()));
                                          }
                                          else if(navigationItems[index].title == "Payment"){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentReportCustomerList()));
                                          }
                                          else if(navigationItems[index].title == "Pending"){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PendingReport()));
                                          }
                                           else{

                                          }
                                          
                                        },
                                        child: new Text(
                                          navigationItems[index].title,
                                          style: GoogleFonts.adamina(
                                              fontSize: 16.0.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                  // Text(navigationItems[index].title),
                                ],
                              ),
                            ),
                          )),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  //margin: EdgeInsets.only(bottom: 15.0),
                  //alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpPage()));
                    },
                    child: Icon(
                      Icons.help_outlined,
                      color: Colors.white,
                      size: 26.0.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          transform: Matrix4.translationValues(xoffset, yoffset, 1.0),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/white_cow.png"),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              Container(
                //alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width * 0.062.w,
                height: MediaQuery.of(context).size.height / 2.9,
                // child: Text("Add Milkman"),
              ),

              //Add Milkman and Add Route
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMilkman()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: 12.0.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 8.0),
                                  child: Text(
                                    "Add Milkman",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/milkman.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddRoute()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 10.0),
                                  child: Text(
                                    "Add Route",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(
                                        top: 3.0.h, right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image:
                                          AssetImage("assets/images/route.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Add Product and CustomerList
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddProduct()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 8.0),
                                  child: Text(
                                    "Add Products",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin:
                                        EdgeInsets.only(top: 3.h, right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/addproduct.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerRouteList()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 8.0),
                                  child: Text(
                                    "Customer List",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/customers.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //BillPay and Payment History
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BillPayCustomerList()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0, bottom: 8.0, right: 8.0),
                                  child: Text(
                                    "Bill Pay",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(
                                        top: 3.0.h, right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/billpay.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery.of(context).size.width * 0.34,
                          height: MediaQuery.of(context).size.height / 6,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            image: DecorationImage(
                              image: AssetImage("assets/images/backcard.png"),
                              fit: BoxFit.fill,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 8.0,
                                    left: 10.0,
                                    right: 8.0),
                                child: Text(
                                  "Payment History",
                                  style: GoogleFonts.adamina(
                                      color: Color(0xFF2B2B81),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0.sp),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.bottomRight,
                                  margin: EdgeInsets.only(right: 14.0),
                                  width: double.infinity,
                                  height: 7.0.h,
                                  child: Image(
                                    image:
                                        AssetImage("assets/images/payment.png"),
                                  ))
                            ],
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
        (_myservices.myVideoStatus == true) ? VideoContainer() : SubContainer()
      ],
    );
  }

  Widget SubContainer() {
    return Stack(
      children: <Widget>[
        Container(
          // width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 15.0, top: 8.0, left: 4.0),
                child: Container(
                  margin: EdgeInsets.only(top: 7.0.h),
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height / 18,
                  child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StartMainPage()));
                        // Navigator.pop(context);
                      },
                      child: Image(
                        image: AssetImage("assets/images/back_icon.png"),
                      )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 15.0, top: 8.0, left: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompanyProfile()));
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height / 22,
                    child: Image(
                      image: AssetImage("assets/images/icon_profile.png"),
                    ),
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                      itemCount: navigationItems.length,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              sidebaropen = false;
                              setsidebarstate();
                            },
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  new RotatedBox(
                                    quarterTurns: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 1.0, left: 40.0),
                                      child: InkWell(
                                        onTap: () {
                                          if(navigationItems[index].title == "Monthly")
                                          {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MonthlyCustomerList()));
                                          }
                                          else if(navigationItems[index].title == "Payment"){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentReportCustomerList()));
                                          }
                                          else if(navigationItems[index].title == "Pending"){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PendingReport()));
                                          }
                                          else{

                                          }
                                          
                                        },
                                        child: new Text(
                                          navigationItems[index].title,
                                          style: GoogleFonts.adamina(
                                              fontSize: 16.0.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                  // Text(navigationItems[index].title),
                                ],
                              ),
                            ),
                          )),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  margin: EdgeInsets.only(left: 1.0.h, bottom: 40.0),
                  alignment: Alignment.centerLeft,                  
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpPage()));
                    },
                    child: Icon(
                      Icons.help_outlined,
                      color: Colors.white,
                      size: 26.0.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          transform: Matrix4.translationValues(xoffset, yoffset, 1.0),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/white_cow.png"),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50.0, right: 5.0),
                alignment: Alignment.topRight,                
                width: MediaQuery.of(context).size.width/1.4,
                height: MediaQuery.of(context).size.height / 3,
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(context: context, builder:
                          (context) => BillgeneratePopup()
                      );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                    image: AssetImage("assets/images/bill_generation.png"),
                    height: 60.0,
                    width: 60.0,
                    fit: BoxFit.cover,
                  ),
                  Text('GENERATE\nBILL',
                  style: TextStyle(fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ),

              //Add Milkman and Add Route
              Container(
                margin: EdgeInsets.only(left: 9.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMilkman()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 8.0),
                                  child: Text(
                                    "Add Milkman",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/milkman.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddRoute()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 10.0),
                                  child: Text(
                                    "Add Route",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(
                                        top: 3.0.h, right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image:
                                          AssetImage("assets/images/route.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Add Product and CustomerList
              Container(
                margin: EdgeInsets.only(left: 9.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddProduct()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 8.0),
                                  child: Text(
                                    "Add Products",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin:
                                        EdgeInsets.only(top: 3.h, right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/addproduct.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerRouteList()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 8.0),
                                  child: Text(
                                    "Customer List",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(right: 14.0),
                                    width: double.infinity,
                                    height: 6.0.h,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/customers.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //BillPay and Payment History
              Container(
                margin: EdgeInsets.only(left: 9.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {                          
                          BillGenerateData();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => BillPayCustomerList()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0, bottom: 8.0, right: 8.0),
                                  child: Text(
                                    "Bill Pay",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(
                                        top: 3.0.h, right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/billpay.png"),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentHistoryList()));
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/backcard.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 8.0,
                                      left: 10.0,
                                      right: 8.0),
                                  child: Text(
                                    "Payment History",
                                    style: GoogleFonts.adamina(
                                        color: Color(0xFF2B2B81),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0.sp),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(right: 14.0),
                                    width: double.infinity,
                                    height: 7.0.h,
                                    child: Image(
                                      image:
                                          AssetImage("assets/images/payment.png"),
                                    ))
                              ],
                            ),
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
      ],
    );
  }

  Widget VideoContainer() {
    String videoId;
    videoId = YoutubePlayer.convertUrlToId("https://youtu.be/KyWVPbV_Hfw");
    print(videoId);

    String thunbnailimage = "https://img.youtube.com/vi/" + videoId;

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true),
    );

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
      child: AlertDialog(
        elevation: 10,
        title: Text(
          'Watch this video before using this App',
          style: GoogleFonts.adamina(
            fontSize: 12.0,
            color: Color(0xFF2B2B81),
          ),
        ),
        content: InkWell(
          onTap: () {
            _launchURL();
          },
          child: Container(
              width: double.infinity,
              height: 150.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("https://img.youtube.com/vi/" +
                          videoId +
                          "/" +
                          "0.jpg"),
                      fit: BoxFit.fill)),
              child: InkWell(
                  onTap: () {
                    launch('https://youtu.be/KyWVPbV_Hfw');
                  },
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Color(0xFF2B2B81),
                    size: 70.0,
                  ))
              // YoutubePlayer(
              //   controller: _controller,
              //   liveUIColor: Colors.amber,
              // ),
              ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _myservices.myVideoStatus = false;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
              child: Text('Close'))
        ],
      ),
    );
    // return BackdropFilter(
    //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    //     child: Dialog(
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    //       child: Container(
    //         alignment: Alignment.center,
    //         color: Colors.transparent,
    //         child: AlertDialog(
    //           title: Text('Welcome'), // To display the title it is optional
    //           content: Text('GeeksforGeeks'), // Message which will be pop up on the screen
    //           // Action widget which will provide the user to acknowledge the choice
    //           actions: [
    //             FlatButton(		 // FlatButton widget is used to make a text to work like a button
    //               textColor: Colors.black,
    //               onPressed: () {},	 // function used to perform after pressing the button
    //               child: Text('CANCEL'),
    //             ),
    //             FlatButton(
    //               textColor: Colors.black,
    //               onPressed: () {},
    //               child: Text('ACCEPT'),
    //             ),
    //           ],
    //         ),
    //       ),
    //     )
    // );
  }

  _launchURL() async {
    if (Platform.isIOS) {
      if (await canLaunch(
          'youtube://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw')) {
        await launch(
            'youtube://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw',
            forceSafariVC: false);
      } else {
        if (await canLaunch(
            'https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw')) {
          await launch(
              'https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw');
        } else {
          throw 'Could not launch https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw';
        }
      }
    } else {
      const url = 'https://youtu.be/KyWVPbV_Hfw';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
