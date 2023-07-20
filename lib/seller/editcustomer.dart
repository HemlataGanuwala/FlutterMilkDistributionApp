import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/buildInputDecoration.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/model/RateModel.dart';
import 'package:milkdistributionflutter/model/RouteModel.dart';

import '../model/CustomerModel.dart';

class EditCustomer extends StatefulWidget{
  int custid;
  EditCustomer(this.custid);

  @override
  EditCustomerState createState() => EditCustomerState(custid);

}

class EditCustomerState extends State<EditCustomer>{
  int custid;
  EditCustomerState(this.custid);

  TextEditingController _name = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _agentcontroller = TextEditingController();
  TextEditingController _cowrate = TextEditingController();
  TextEditingController _buffrate = TextEditingController();
  TextEditingController _remark = TextEditingController();
  TextEditingController _custbal = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formratekey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String radioItem = '';
  int cowcount = 0, buffcount = 0,cowcounthalf = 0, buffcounthalf = 0;
  double setcowrate = 0, setbuffrate = 0, totalamtcow = 0,totalamtbuff = 0;
  DateTime selectedDate = DateTime.now();
  String regdate = "", dcmonth, dcyear, dcday;
  String dropdownValue = 'Active';
  bool chkcow = false;
  bool chkbuffalo = false;
  MyServices _myServices = new MyServices();
  List<RouteModel> _route;
  List<RateModel> _ratelist;
  String selectroute,routenm,agentnm,agentid,routeid,cowmilk = "",buffmilk = "";
  bool loading = false;
  List< CustomerModel > customerList;
  Future<List<CustomerModel>> customerfuture;

  List <String> spinnerItems = [
    'Active',
    'Deactive',
  ] ;

  @override
  void initState() {
    GetRatemodel().then((value) => setState(() {}));
    GetRoutemodel().then((value) => setState(() {}));
    super.initState();
    EasyLoading.show(status: "Loading.....");
    customerfuture = getCustomerDataIdWise();
    //regdate = selectedDate.day.toString()+"/"+selectedDate.month.toString()+"/"+selectedDate.year.toString();
  }

  Future GetRoutemodel() async{
    loading = true;
    Map<String, String> JsonBody = {
      'CompanyId':_myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Route/GetRoute"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    final json = jsonDecode(response.body)['Response'];

    // _milkman = jsonDecode(response.body)['Response'];
    setState(() {
      _route = (json)
          .map<RouteModel>((item) => RouteModel.fromJson(item))
          .toList();
    });
    loading = false;
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
      _name.text = mlist[0].CustomerName;
      _mobile.text = mlist[0].MobileNo;
      _address.text = mlist[0].Address;        
      _agentcontroller.text = mlist[0].Agentname;
      dropdownValue = mlist[0].CustomerStatus;        
      cowmilk = mlist[0].Cowmilk;
      if(cowmilk == "Cow Milk"){
        chkcow = true;
      }
      buffmilk = mlist[0].Buffalomilk;
      if(buffmilk == "Buffallo Milk"){
        chkbuffalo = true;
      }
      cowcount = mlist[0].Cowmilkqty;
      cowcounthalf = mlist[0].Cowmilkhalfqty;
      _cowrate.text = mlist[0].Cowmilkrate.toString();
      totalamtcow = mlist[0].Cowmilktotamt;
      buffcount = mlist[0].Buffallomilkqty;
      buffcounthalf = mlist[0].Buffallomilkhalfqty;
      _buffrate.text = mlist[0].Buffallomilkrate.toString();
      totalamtbuff = mlist[0].Buffallomilktotamt;
      _remark.text = mlist[0].Remark;
      if(_remark.text == "null")
      {
        _remark.text = "";
      }
      _custbal.text = mlist[0].Oldbalance;
      if(_custbal.text == "null")
      {
        _custbal.text = "";
      }
      regdate = mlist[0].Cdate;
      dcday = mlist[0].Cday;
      dcmonth = mlist[0].Cmonth;
      dcyear = mlist[0].Cyear;
      radioItem = mlist[0].Deliverytime;
      if(radioItem == "Morning"){
        radioItem = "Morning";
      }
      else{
        radioItem = "Evening";
      }
      selectroute = mlist[0].Agentname +","+ mlist[0].Routename +","+ mlist[0].Agentid.toString() +","+ mlist[0].Routeid.toString();
      agentnm = selectroute.split(",")[0];
      routenm = selectroute.split(",")[1];
      agentid = selectroute.split(",")[2];
      routeid = selectroute.split(",")[3];
      return customerList;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future GetRatemodel() async{
    loading = true;
    Map<String, String> JsonBody = {
      'CompanyId':_myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Rate/GetRateData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    final json = jsonDecode(response.body)['Response'];

    // _milkman = jsonDecode(response.body)['Response'];
    setState(() {
      _ratelist = (json)
          .map<RateModel>((item) => RateModel.fromJson(item))
          .toList();
      final mlist = _ratelist.asMap();
      String cowr = mlist[0].Cowrate;
      String buffr = mlist[0].Buffallorate;
      if(cowr == null)
        {
          cowr = "0";
        }
      if(buffr == null)
      {
        buffr = "0";
      }
      setcowrate = double.parse(cowr);
      setbuffrate = double.parse(buffr);
      _cowrate.text = setcowrate.toString();
      _buffrate.text = setbuffrate.toString();
      loading = false;
    });
  }
  
  Widget Buffallowidget(){
    return Container(
      margin: EdgeInsets.only(top: 5.0,left: 10.0, right: 10.0),
      height: 130.0,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,  // red as border color
          ),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: <Widget>[
          CheckboxListTile(
            onChanged: (bool value){
              setState(() {
                chkbuffalo = value;
                if(chkbuffalo == true)
                {
                  buffmilk = "Buffallo Milk";
                }
              });
            },
            value: chkbuffalo,
            contentPadding: EdgeInsets.all(0),
            title: Text("Buffallo Milk",
              style: GoogleFonts.adamina(fontSize: 13.0,color: Colors.black87),),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Container(
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Quantity",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  // color: Color(0xFF2B2B81),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2B2B81),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          setState(() {
                            if(buffcount > 0)
                            {
                              buffcount--;
                              totalamtbuff = (buffcount * setbuffrate)+(buffcounthalf * (setbuffrate/2));
                            }
                            else{

                            }
                          });
                        },
                        child: Icon(Icons.remove,size: 24.0,color: Colors.white,),),
                      Text(buffcount.toString(),style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: (){
                          setState(() {
                            buffcount++;
                            totalamtbuff = (buffcount * setbuffrate)+(buffcounthalf * (setbuffrate/2));
                          });
                        },
                        child: Icon(Icons.add,size: 24.0,color: Colors.white,),),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  // color: Color(0xFF2B2B81),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2B2B81),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          setState(() {
                            if(buffcounthalf > 0)
                            {
                              buffcounthalf--;
                              totalamtbuff = (buffcount * setbuffrate)+(buffcounthalf * (setbuffrate/2));
                            }
                            else{

                            }
                          });
                        },
                        child: Icon(Icons.remove,size: 24.0,color: Colors.white,),),
                      Text(buffcounthalf.toString(),style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: (){
                          setState(() {
                            buffcounthalf++;
                            totalamtbuff = (buffcount * setbuffrate)+(buffcounthalf * (setbuffrate/2));
                          });
                        },
                        child: Icon(Icons.add,size: 24.0,color: Colors.white,),),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Rate",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: 100,
                  height: 30.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,  // red as border color
                      ),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(controller: _buffrate,style: GoogleFonts.adamina(fontWeight: FontWeight.bold,fontSize: 14.0),
                        decoration: InputDecoration(border: InputBorder.none)),
                  ),
                ),
                Text("TAmt",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: 100,
                  height: 30.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,  // red as border color
                      ),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                    child: Text(totalamtbuff.toString(),style: GoogleFonts.adamina(fontWeight: FontWeight.bold,fontSize: 14.0),
                      textAlign: TextAlign.center,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget Sessionwidget(){
    return Container(
      margin: EdgeInsets.only(top: 5.0,left: 10.0, right: 10.0),
      height: 80.0,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,  // red as border color
          ),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10.0,top: 5.0),
            child: Text("Enter the session",
              style: GoogleFonts.adamina(fontSize: 16.0,color: Color(0xFF2B2B81),fontWeight: FontWeight.bold,),),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  groupValue: radioItem,
                  value: 'Morning',
                  onChanged: (val) {
                    setState(() {
                      radioItem = val;
                    });
                  },
                ),
                Text(
                  'Morning',
                  style: GoogleFonts.adamina(fontSize: 16.0,color: Color(0xFF2B2B81)),
                ),
                Radio(
                  groupValue: radioItem,
                  value: 'Evening',
                  onChanged: (val) {
                    setState(() {
                      radioItem = val;
                    });
                  },
                ),
                Text(
                  'Evening',
                  style: GoogleFonts.adamina(fontSize: 16.0,color: Color(0xFF2B2B81)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget Selectmilktype(){
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        children: <Widget>[
          Text("Select the milk type",style: GoogleFonts.adamina(
              fontSize: 16.0, fontWeight: FontWeight.bold,color: Color(0xFF2B2B81)
          ),),
          Spacer(),

        ],
      ),
    );
  }

  Widget Cowwidget(){
    return Container(
      margin: EdgeInsets.only(top: 5.0,left: 10.0, right: 10.0),
      height: 130.0,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,  // red as border color
          ),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: <Widget>[
          CheckboxListTile(
            onChanged: (bool value){
              setState(() {
                // if(cowmilk == "Cow Milk"){
                //   chkcow = true;
                // }
                chkcow = value;
                if(chkcow == true)
                  {
                    cowmilk = "Cow Milk";
                  }
              });
            },
            value: chkcow,
            contentPadding: EdgeInsets.all(0),
            title: Text("Cow Milk",
              style: GoogleFonts.adamina(fontSize: 13.0,color: Colors.black87),),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Text("Quantity",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  // color: Color(0xFF2B2B81),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2B2B81),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap:(){
                          setState(() {
                            if(cowcount > 0)
                            {
                              cowcount--;
                              totalamtcow = (cowcount * setcowrate) + (cowcounthalf * (setcowrate/2));
                            }
                            else{

                            }
                          });
                        },
                        child: Icon(Icons.remove,size: 24.0,color: Colors.white,),),
                      Text(cowcount.toString(),style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: (){
                          setState(() {
                            cowcount++;
                            totalamtcow = (cowcount * setcowrate) + (cowcounthalf * (setcowrate/2));
                          });
                        },
                        child: Icon(Icons.add,size: 24.0,color: Colors.white,),)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  // color: Color(0xFF2B2B81),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2B2B81),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap:(){
                          setState(() {
                            if(cowcounthalf > 0)
                            {
                              cowcounthalf--;
                              totalamtcow = (cowcount * setcowrate) + (cowcounthalf * (setcowrate/2));
                            }
                            else{

                            }
                          });
                        },
                        child: Icon(Icons.remove,size: 24.0,color: Colors.white,),
                        // child: Text("-",style: GoogleFonts.adamina(fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.bold),)
                      ),
                      Text(cowcounthalf.toString(),style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: (){
                          setState(() {
                            cowcounthalf++;
                            totalamtcow = (cowcount * setcowrate) + (cowcounthalf * (setcowrate/2));
                          });
                        },
                        child: Icon(Icons.add,size: 24.0,color: Colors.white,),)
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Rate",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  width: 100,
                  height: 30.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,  // red as border color
                      ),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: TextField(controller: _cowrate,style: GoogleFonts.adamina(fontWeight: FontWeight.bold,fontSize: 14.0),
                        decoration: InputDecoration(border: InputBorder.none)),
                  ),
                ),
                Text("TAmt",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: 100,
                  height: 30.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,  // red as border color
                      ),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                    child: Text(totalamtcow.toString(),style: GoogleFonts.adamina(fontWeight: FontWeight.bold,fontSize: 14.0,),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future EditCustomerData() async{
    loading = true;
    Map<String, String> JsonBody = {
      'Id':custid.toString(),
      'CustomerName':_name.text,
      'AgentName':_agentcontroller.text,
      'MobileNo':_mobile.text,
      'Address':_address.text,
      'CowMilk':cowmilk,
      'CowMilkRate':_cowrate.text,
      'CowMilkTotAmt':totalamtcow.toString(),
      'CowMilkQty':cowcount.toString(),
      'CowHalfMilkQty':cowcounthalf.toString(),
      'BuffaloMilk':buffmilk,
      'BuffalloMilkQty':buffcount.toString(),
      'BuffalloHalfMilkQty':buffcounthalf.toString(),
      'BuffalloMilkRate':_buffrate.text,
      'BuffalloMilkTotAmt':totalamtbuff.toString(),
      'Cday':selectedDate.day.toString(),
      'Cyear':selectedDate.year.toString(),
      'Cmonth':selectedDate.month.toString(),
      'DeliveryTime':radioItem,
      'CustomerStatus':dropdownValue,
      'Remark':_remark.text,
      'CDate':regdate,
      'OldBalance':_custbal.text,
      'RouteName':routenm,
      'RouteID':routeid,
      'GeoLocation':"",
      'AgentID':agentid,
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Customer/EditCustomer"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Edit successfully"),
            duration: Duration(seconds: 3),
          ));
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
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Edit Customer"),
      backgroundColor: Color(0xFF2B2B81),
      ),
      body: SingleChildScrollView(
        // physics: ScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              loading ? Center(child: CircularProgressIndicator(),):
              Container(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 10.0),
                        child: TextFormField(controller: _name,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          decoration:buildInputDecoration(FontAwesomeIcons.solidUser,"Name"),
                            validator: (String value){
                              if(value.isEmpty)
                              {
                                return "Please enter Customer Name";
                              }
                              return null;
                            },
                            onSaved: (String name){
                            }, ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                        child: TextFormField(controller: _mobile,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.phone,
                          decoration:buildInputDecoration(FontAwesomeIcons.mobile,"Mobile No."),
                            validator: (String value){
                              if(_mobile == "")
                              {
                                if (value.length != 10)
                                  return 'Mobile Number must be of 10 digit';
                                else
                                  return null;
                              }
                              return null;
                            },
                            onSaved: (String name){
                            },),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                        child: TextFormField(controller: _address,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.streetAddress,
                          decoration:buildInputDecoration(FontAwesomeIcons.streetView,"Address"),
                          validator: (String value){
                            if(value.isEmpty)
                            {
                              return "Please enter Address";
                            }
                            return null;
                          },
                          onSaved: (String name){
                          },),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    Selectmilktype(),

                    //*************************************************Cow Milk**********************************************

                    Cowwidget(),

                    //***************************************Buffallow Milk******************************************

                    Buffallowidget(),

                    //****************************************session***********************************************

                    Sessionwidget(),

                    //Route
                    Container(
                      margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                      height: 50.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0,color: Colors.grey,style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0, right: 8.0),
                        child: DropdownButton<String>(
                          value: selectroute,
                          isExpanded: true,
                          hint: Text("Select Route"),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Color(0xFF2B2B81), fontSize: 18),
                          underline: Container(),
                          onChanged: (String data) {
                            setState(() {
                              selectroute = data;
                              agentnm = data.split(",")[0];
                              routenm = data.split(",")[1];
                              agentid = data.split(",")[2];
                              routeid = data.split(",")[3];
                              _agentcontroller.text = agentnm;
                            });
                          },
                          items: _route.map((RouteModel list) {
                            return DropdownMenuItem<String>(
                              value: list.AgentName + "," + list.RouteName+ "," + list.AgentId.toString()+ "," + list.Id.toString(),
                              child: Text(list.RouteName),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    //AgentName
                    Container(
                      margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                      height: 50.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0,color: Colors.grey,style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(controller: _agentcontroller,style: GoogleFonts.adamina(fontSize: 14.0,),
                            decoration: InputDecoration(border: InputBorder.none,
                            hintText: "Agent Name",),
                            textInputAction: TextInputAction.next,),
                      ),
                    ),
                    //Customer Status
                    Container(
                      margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0,color: Colors.grey,style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Color(0xFF2B2B81), fontSize: 18),
                          underline: Container(),
                          onChanged: (String data) {
                            setState(() {
                              dropdownValue = data;
                            });
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
                    //Remark
                    Container(
                      margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                      height: 50.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0,color: Colors.grey,style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(controller: _remark,style: GoogleFonts.adamina(fontSize: 14.0,),
                          decoration: InputDecoration(border: InputBorder.none,
                              hintText: "Remark"),
                          textInputAction: TextInputAction.next,),
                      ),
                    ),
                    //Enter Customer Balance
                    Container(
                      margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                      height: 50.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0,color: Colors.grey,style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(controller: _custbal,style: GoogleFonts.adamina(fontSize: 14.0,),
                          decoration: InputDecoration(border: InputBorder.none,
                              hintText: "Customer Balance"),
                          textInputAction: TextInputAction.next,),
                      ),
                    ),
                    //Reg Date
                    InkWell(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                        height: 50.0,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0,color: Colors.grey,style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: InkWell(
                          onTap: (){
                            _selectDate(context);
                            setState(() {
                              regdate = selectedDate.day.toString()+"/"+selectedDate.month.toString()+"/"+selectedDate.year.toString();
                            });

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(regdate.split(' ')[0],
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height/18,
                              width: MediaQuery.of(context).size.width/3,
                              decoration: BoxDecoration(
                                color: Color(0xFF2B2B81),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ButtonTheme(
                                minWidth: 150,
                                height: 40,
                                child: TextButton(
                                  onPressed: (){
                                    if(_formkey.currentState.validate())
                                    {
                                      if(chkcow != false || chkbuffalo != false)
                                        {
                                            if(cowcount != 0 || cowcounthalf != 0 || buffcount != 0 || buffcounthalf != 0)
                                              {
                                                  if(_buffrate.text != 0.0 || _cowrate.text != 0.0)
                                                    {
                                                        if(_agentcontroller.text != "Select Route")
                                                          {
                                                            EasyLoading.show(status: "Loading.....");
                                                            EditCustomerData();
                                                          }
                                                        else{
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text("Select Milkman"),
                                                                duration: Duration(seconds: 3),
                                                              ));
                                                        }
                                                    }
                                                  else{
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text("Add Milk Rate"),
                                                          duration: Duration(seconds: 3),
                                                        ));
                                                  }
                                              }
                                            else{
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Select milk quantity"),
                                                    duration: Duration(seconds: 3),
                                                  ));
                                            }
                                        }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Select Cow milk or Buffallo milk"),
                                              duration: Duration(seconds: 3),
                                            ));
                                      }
                                      // EditRouteData();
                                      print("Successful");
                                    }else
                                    {
                                      print("Unsuccessfull");
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(color: Colors.white,
                                        backgroundColor: Color(0xFF2B2B81)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: Text("SUBMIT",
                                      style: GoogleFonts.adamina(fontSize: 16.0, color: Colors.white)),),
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
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dcday = selectedDate.day.toString();
        dcmonth = selectedDate.month.toString();
        dcyear = selectedDate.year.toString();
        regdate = selectedDate.day.toString()+"/"+selectedDate.month.toString()+"/"+selectedDate.year.toString();
      });
  }

  
}