import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../MyServices.dart';
import '../model/CustomerModel.dart';
import 'calender.dart';

class EvenOdd extends StatefulWidget {
  int custid;
  String cmonth,cyear;
  EvenOdd(this.custid,this.cmonth,this.cyear);

  @override
  State<StatefulWidget> createState() {
    return EvenOddState(custid,cmonth,cyear);
  }
}

class EvenOddState extends State<EvenOdd> {
  int custid;
  String cmonth,cyear;
  EvenOddState(this.custid,this.cmonth,this.cyear);
  MyServices _myServices = new MyServices();
  TextEditingController textControllerFromDate = new TextEditingController();
  TextEditingController textControllerToDate = new TextEditingController();
  String plantodate, planfromdate;
  String sday,smonth,syear,sdate,cowmilk,buffmilk,custnm,mobile,address,custstatus,pin,agentnm,milkstatus,totalamt,oldbal;
  int _coneqty = 0,_boneqty = 0,_chalfqty = 0,_bhalfqty = 0,vcqty = 0,vchqty = 0,vbqty = 0,vbhqty = 0,changeconeqty,changeboneqty,changechalfqty,changebhalfqty,proid;
  double ctotamt,btotamt,crate,brate;
  int cowcount = 0, buffcount = 0, cowcounthalf = 0, buffcounthalf = 0;
  double setcowrate = 0, setbuffrate = 0, totalamtcow = 0, totalamtbuff = 0;
  TextEditingController _cowrate = TextEditingController();
  TextEditingController _buffrate = TextEditingController();
  TextEditingController _cowoneqty = TextEditingController();
  TextEditingController _cowhalfqty = TextEditingController();
  TextEditingController _buffoneqty = TextEditingController();
  TextEditingController _buffhalfqty = TextEditingController();
  bool loading = false;
  Future<List<CustomerModel>> customerfuture;
  List< CustomerModel > customerList;
  List<String> spinnerItems = [
    'Select',
    'Even',
    'Odd',
  ];
  String dropdownValue = 'Select';

  @override
  void initState(){
    super.initState();
    EasyLoading.show(status: "Loading.....");
    customerfuture = getCustomerDataIdWise();    
  }

  Future<List<CustomerModel>> getCustomerDataIdWise() async{
    Map<String, String> JsonBody = {
      'CompanyId':  _myServices.myCompanyId,
      'Id':  custid.toString(),
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Customer/GetIdwiseCustomer"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      customerList= List< CustomerModel >.from((json.decode(response.body)['Response']).map((i) => CustomerModel.fromJson(i))).toList();
      EasyLoading.dismiss();
      final mlist = customerList.asMap();
      custnm = mlist[0].CustomerName;
      mobile = mlist[0].MobileNo;
      address = mlist[0].Address;
      pin = mlist[0].Pin;
      agentnm = mlist[0].Agentname;
      custstatus = mlist[0].CustomerStatus;
      custnm = mlist[0].CustomerName;
      cowmilk = mlist[0].Cowmilk;
      buffmilk = mlist[0].Buffalomilk;
      _coneqty = mlist[0].Cowmilkqty;
      _chalfqty = mlist[0].Cowmilkhalfqty;
      crate = mlist[0].Cowmilkrate;
      ctotamt = mlist[0].Cowmilktotamt;
      _boneqty = mlist[0].Buffallomilkqty;
      _bhalfqty = mlist[0].Buffallomilkhalfqty;
      brate = mlist[0].Buffallomilkrate;
      btotamt = mlist[0].Buffallomilktotamt;
      _cowrate.text = crate.toString();
      _buffrate.text = brate.toString();
      vcqty = _coneqty;
      vchqty = _chalfqty;
      vbqty = _boneqty;
      vbhqty = _bhalfqty;
      _cowoneqty.text = _coneqty.toString();
      _cowhalfqty.text = _chalfqty.toString();
      _buffoneqty.text = _boneqty.toString();
      _buffhalfqty.text = _bhalfqty.toString();
      return customerList;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future AddNomilkData() async{
    loading = true;
    Map<String, String> JsonBody = {      
      'CustId':custid.toString(),    
      'DeliveryType':dropdownValue, 
      'Cmonth':cmonth, 
      'Cyear':cyear,          
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Customer/UpdateEvenOddCustomer"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added successfully"),
            duration: Duration(seconds: 3),
          )); 
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalenderPage(custid)));

    }
    else{
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 3),
          ));
    }

    print("DATA: ${data}");
  }

  Future AddMinMaxMilkData() async{
    loading = true;
    Map<String, String> JsonBody = {
      'CustId':custid.toString(),    
      'CowMilkQty':vcqty.toString(), 
      'CowHalfMilkQty':vchqty.toString(), 
      'CowMilkRate':crate.toString(), 
      'BuffalloMilkQty':vbqty.toString(), 
      'BuffalloHalfMilkQty':vbhqty.toString(), 
      'BuffalloMilkRate':brate.toString(),  
      'TotalAmt': (ctotamt + btotamt).toString(),  
      'DeliveryType':dropdownValue, 
      'Cmonth':cmonth, 
      'Cyear':cyear,        
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Customer/UpdateMinMaxMilk"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added successfully"),
            duration: Duration(seconds: 3),
          )); 
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalenderPage(custid)));

    }
    else{
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 3),
          ));
    }

    print("DATA: ${data}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width - 70,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    color: Color(0xFF2B2B81),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                      Text(
                      "Even/Odd Changes",
                      style: GoogleFonts.adamina(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, 
                    icon: Icon(
                      Icons.cancel_presentation_sharp, 
                      color: Colors.white, size: 30.0,))
                    ],)
                  ),
                  selectevenodd(),
                  Container(
                    child: FutureBuilder<List<CustomerModel>>(
                      future: customerfuture,
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if(snapshot.hasData){
                          List<CustomerModel> cartitem = snapshot.data;
                        }
                        return Column(
                          children: <Widget>[
                            if(cowmilk != null)
                          cowwidget(),
                        
                        if(buffmilk != null)
                          buffallowidget(),
                        
                          ],
                        );
                        
                      }),
                    ),
                  ),
                  
                  // cowwidget(),
                  // buffallowidget(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 8.0, right: 8.0, bottom: 15.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 20,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Color(0xFF2B2B81),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: TextButton(
                          onPressed: () {
                            if(dropdownValue == "Select")
                            {
                              Fluttertoast.showToast(
                                      msg: "Select Even/Odd First",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                    );
                                    return;
                            }
                            else if(vcqty.toString() == _cowoneqty.text && vchqty.toString() == _cowhalfqty.text &&
                            vbqty.toString() == _buffoneqty.text && vbhqty.toString() == _buffhalfqty.text){
                              Fluttertoast.showToast(
                                      msg: "Change Quantity First",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                    );
                                    return;
                            }
                            else{
                              EasyLoading.show(status: "Loading.....");
                              AddMinMaxMilkData();
                            }
                            
                          },
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                                color: Colors.white,
                                backgroundColor: Color(0xFF2B2B81)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text("MinMaxMilk Submit",
                              style: GoogleFonts.adamina(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectevenodd() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height / 20,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10.0),
                  dropdownColor: Colors.white,
                  value: dropdownValue,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF2B2B81),
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: Container(),
                  onChanged: (String data) {
                    setState(() {
                      dropdownValue = data;
                    });
                    
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                color: Color(0xFF2B2B81),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ButtonTheme(
                minWidth: 150,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    if(dropdownValue == "Select")
                    {
                      Fluttertoast.showToast(
                              msg: "Select Even/Odd First",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                            return;
                    }
                    else{
                      EasyLoading.show(status: "Loading.....");
                      AddNomilkData();
                    }
                    
                  },
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        color: Colors.white,
                        backgroundColor: Color(0xFF2B2B81)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("NoMilk Submit",
                      style: GoogleFonts.adamina(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cowwidget() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
      height: MediaQuery.of(context).size.height / 10,     
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Text(
                  "Cow Quantity",
                  style: GoogleFonts.adamina(
                      fontSize: 12.0, color: Colors.black87),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  // color: Color(0xFF2B2B81),
                  width: MediaQuery.of(context).size.width / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Color(0xFF2B2B81),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (vcqty > 0) {
                              vcqty--;
                              // _cowoneqty.text = _coneqty.toString();
                              ctotamt = (vcqty * crate)+(vchqty * (crate/2));
                             
                            } else {}
                          });
                        },
                        child: Icon(
                          Icons.remove,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        vcqty.toString(),
                        style: GoogleFonts.adamina(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            vcqty++;
                            // _cowoneqty.text = _coneqty.toString();
                            ctotamt = (vcqty * crate)+(vchqty * (crate/2));
                            
                          });
                        },
                        child: Icon(
                          Icons.add,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  // color: Color(0xFF2B2B81),
                  width: MediaQuery.of(context).size.width / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Color(0xFF2B2B81),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (vchqty > 0) {
                               vchqty--;
                              //  _cowhalfqty.text = _chalfqty.toString();
                                ctotamt = (vcqty * crate)+(vchqty * (crate/2));
                              
                            } else {}
                          });
                        },
                        child: Icon(
                          Icons.remove,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        // child: Text("-",style: GoogleFonts.adamina(fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.bold),)
                      ),
                      Text(
                        vchqty.toString(),
                        style: GoogleFonts.adamina(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                             vchqty++;
                            //  _cowhalfqty.text = _chalfqty.toString();
                              ctotamt = (vcqty * crate)+(vchqty * (crate/2));
                          
                          });
                        },
                        child: Icon(
                          Icons.add,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // red as border color
                ),
                borderRadius: BorderRadius.circular(10.0)),
            margin: EdgeInsets.only(top: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Rate",
                    style: GoogleFonts.adamina(
                        fontSize: 12.0, color: Colors.black87),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.height / 28,
                    child: TextField(
                        controller: _cowrate,
                        style: GoogleFonts.adamina(
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "0.0")),
                  ),
                  Text(
                    "TAmt",
                    style: GoogleFonts.adamina(
                        fontSize: 12.0, color: Colors.black87),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.height / 28,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 6.0),
                      child: Text(ctotamt.toString(),
                          style: GoogleFonts.adamina(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buffallowidget() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
      height: MediaQuery.of(context).size.height / 10,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Buffalo Quantity",
                    style: GoogleFonts.adamina(
                        fontSize: 12.0, color: Colors.black87),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: MediaQuery.of(context).size.width / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Color(0xFF2B2B81),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (vbqty > 0) {
                               vbqty--;
                              // _buffoneqty.text = _boneqty.toString();
                              btotamt = (vbqty * brate)+(vbhqty * (brate/2));
                            } else {}
                          });
                        },
                        child: Icon(
                          Icons.remove,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        vbqty.toString(),
                        style: GoogleFonts.adamina(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            vbqty++;
                              // _buffoneqty.text = _boneqty.toString();
                              btotamt = (vbqty * brate)+(vbhqty * (brate/2));
                          });
                        },
                        child: Icon(
                          Icons.add,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: MediaQuery.of(context).size.width / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Color(0xFF2B2B81),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (vbhqty > 0) {
                              vbhqty--;
                              // _buffhalfqty.text = _bhalfqty.toString();
                              btotamt = (vbqty * brate)+(vbhqty * (brate/2));
                            } else {}
                          });
                        },
                        child: Icon(
                          Icons.remove,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        vbhqty.toString(),
                        style: GoogleFonts.adamina(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            vbhqty++;
                              // _buffhalfqty.text = _bhalfqty.toString();
                              btotamt = (vbqty * brate)+(vbhqty * (brate/2));
                          });
                        },
                        child: Icon(
                          Icons.add,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // red as border color
                ),
                borderRadius: BorderRadius.circular(10.0)),
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Rate",
                  style: GoogleFonts.adamina(
                      fontSize: 12.0, color: Colors.black87),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.height / 28,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _buffrate,
                      style: GoogleFonts.adamina(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "0.0"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Text(
                  "TAmt",
                  style: GoogleFonts.adamina(
                      fontSize: 12.0, color: Colors.black87),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.height / 28,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 6.0),
                    child: Text(
                      btotamt.toString(),
                      style: GoogleFonts.adamina(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
