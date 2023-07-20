import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/CompanyRegistration.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/Reg.dart';
import 'package:milkdistributionflutter/buyer/buyerdashboard.dart';
import 'package:milkdistributionflutter/milkman/checkcompanyid.dart';
import 'package:milkdistributionflutter/milkman/milkman_route_list.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../DatabaseHelper.dart';
import 'package:sizer/sizer.dart';

import '../buyer/buyercheckcompanyid.dart';

class StartMainPage extends StatefulWidget{
  @override
  StartMainPageState createState() => StartMainPageState();
}

class StartMainPageState extends State<StartMainPage>{

  Reg _reg = new Reg();
  List< Reg > regList;
  List< MilkmanReg > milkmanRegList;
  List< BuyerReg > buyerRegList;
  MyServices _myServices = new MyServices();
  String companyid = "", milkCompanyId = "",milkPin = "", buyerPin="", buyerCompanyId = "";
  int  loginstatus, milkLoginStatus, buyerLoginStatus;
  String selectBM = "";

  @override
  void initState() {
    super.initState();
    getRegData().then((value) => getMilkmanRegData().then((value) => getBuyerRegData()));
    
  }

  Future<List<Reg>> getRegData() async{
    regList = await DatabaseHelper.db.getAllCustomers();
    if(regList.length != 0)
    {
      final mlist = regList.asMap();
      companyid = mlist[0].company_id;
      _myServices.myCompanyId = companyid;
      loginstatus = mlist[0].Status;
    }
    return regList;
  }

  Future<List<MilkmanReg>> getMilkmanRegData() async{
    milkmanRegList = await DatabaseHelper.db.getAllMilkman();
    if(milkmanRegList.length != 0)
    {
      final mlist = milkmanRegList.asMap();
      milkCompanyId = mlist[0].company_id;
      milkPin = mlist[0].pin;
      _myServices.myMilkCompanyId = milkCompanyId;
      _myServices.myMilkPin = milkPin;
      milkLoginStatus = mlist[0].Status;
    }
    return milkmanRegList;
  }

  Future<List<BuyerReg>> getBuyerRegData() async{
    buyerRegList = await DatabaseHelper.db.getAllBuyer();
    if(buyerRegList.length != 0)
    {
      final mlist = buyerRegList.asMap();
      buyerCompanyId = mlist[0].company_id;
      buyerPin = mlist[0].pin;
      _myServices.myBuyerCompanyId = buyerCompanyId;
      _myServices.myBuyerPin = buyerPin;
      buyerLoginStatus = mlist[0].Status;
    }
    return buyerRegList;
  }

  bool isTimerRunning = false;

  startTimeout([int milliseconds]) {
    isTimerRunning = true;
    var timer = new Timer.periodic(new Duration(seconds: 2), (time) {
      isTimerRunning = false;
      time.cancel();
    });
  }

  void _showToast(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Press back again to exit",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<bool> _willPopCallback() async {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
    // if (!isTimerRunning) {
    //   startTimeout();
    //   _showToast(context);
    //   return false;
    // } else
    //   return true;
    // int stackCount = Navigator.of(context).getNavigationHistory().length;
    // if (stackCount == 1) {
    //   if (!isTimerRunning) {
    //     startTimeout();
    //     _showToast(context);
    //     return false;
    //   } else
    //     return true;
    // } else {
    //   isTimerRunning = false;
    //   return true;
    // }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: new Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 100.h,
          width: MediaQuery.of(context).size.width * 100.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF2333AD),Color(0xFFd1cfed), Color(0xFF2333AD)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
          ),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 30.0.w,
                      height: 30.0.h,
                      margin: EdgeInsets.only(top: 3.0.h),
                      child: Image(image: AssetImage("assets/images/milklogo.png"),)),
                ),
                InkWell(
                  onTap: (){
                    if(loginstatus == 1)
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                      }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyRegistration()));
                    }

                  },
                  child: Container(
                    height: 7.0.h,
                    width: 60.w,
                    margin: EdgeInsets.only(top: 3.0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF2333AD),
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Text("SELLER",style: GoogleFonts.adamina(fontSize: 14.0.sp,color: Colors.white,
                        fontWeight: FontWeight.bold)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if(buyerLoginStatus == 1)
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerDashboard()));
                      }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerCheckCompanyId()));
                    }
                  },
                  child: Container(
                    height: 7.0.h,
                    width: 60.w,
                    margin: EdgeInsets.only(top: 4.0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xFF2333AD),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Text("BUYER",style: GoogleFonts.adamina(fontSize: 14.0.sp,color: Colors.white,
                        fontWeight: FontWeight.bold)),
                  ),
                ),
                InkWell(
                  onTap: () {                    
                    if(milkLoginStatus == 1)
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MilkmanRouteList()));
                      }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckCompanyId()));
                    }
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CheckCompanyId()));
                  },
                  child: Container(
                    height: 7.0.h,
                    width: 60.w,
                    margin: EdgeInsets.only(top: 4.0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xFF2333AD),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Text("MILKMAN",style: GoogleFonts.adamina(fontSize: 14.0.sp,color: Colors.white,
                        fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                    width: 80.0.w,
                    height: 25.0.h,
                    margin: EdgeInsets.only(top: 3.0.h),
                    child: Image(image: AssetImage("assets/images/splashmilk.png"),)),
              ],
            ),
          ),
        ),
      ),
    );
  }

}