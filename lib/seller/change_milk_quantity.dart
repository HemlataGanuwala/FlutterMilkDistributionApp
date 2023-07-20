import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/model/CustomerModel.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/model/DeliveryStatusModel.dart';
import 'package:milkdistributionflutter/model/ProductModel.dart';
import 'package:milkdistributionflutter/model/ProductNameModel.dart';
import 'package:milkdistributionflutter/seller/calender.dart';

import '../MyServices.dart';

class ChangeMilkQuantity extends StatefulWidget{
  String sday,smonth,syear,sdate;
  int custid;
  ChangeMilkQuantity(this.sday, this.smonth,this.syear,this.sdate,this.custid);

  @override
  State<StatefulWidget> createState() {
    return ChangeMilkQuantityState(sday,smonth,syear,sdate,custid);
  }
}

class ChangeMilkQuantityState extends State<ChangeMilkQuantity>{
  String sday,smonth,syear,sdate,cowmilk,buffmilk,custnm,mobile,address,custstatus,pin,agentnm,milkstatus,totalamt,oldbal;
  int custid,_coneqty = 0,_boneqty = 0,_chalfqty = 0,_bhalfqty = 0,changeconeqty,changeboneqty,changechalfqty,changebhalfqty,proid;
  double ctotamt,btotamt,crate,brate;
  ChangeMilkQuantityState(this.sday, this.smonth,this.syear,this.sdate,this.custid);
  String dropdownValue = 'Select';
  bool viewVisible = false;
  bool viewDetailsVisible = false;
  List <String> spinnerItems = [
    'Select',
    'No Milk',
    'Min/Max',
    'Add Product'
  ] ;
  MyServices _myServices = new MyServices();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<CustomerModel>> customerfuture;
  Future<List<ProductModel>> productdetailsfuture;
  List< CustomerModel > customerList;
  List<ProductNameModel> _productname;
  List<ProductModel> _productqty;
  List<ProductModel> _productstatuslist;
  String dropproductnm,dropproductqty,droppronmid,droprate = "",dropproshnm = "",dropprounit,proname,dropqty,dropunit;

  void showWidget(){
    setState(() {
      viewVisible = true ;
    });
  }

  void hideWidget(){
    setState(() {
      viewVisible = false ;
    });
  }

  void showDetailsWidget(){
    setState(() {
      viewDetailsVisible = true ;
    });
  }

  void navigateToAddProduct() async {
    Navigator.of(context).push
      (new MaterialPageRoute(builder: (context) => ChangeMilkQuantity(sday, smonth, syear, sdate, custid)))
        .whenComplete((){setState(() {
      getProductStatusData();
    });});
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: "Loading.....");
    customerfuture = getCustomerDataIdWise();
    productdetailsfuture = getProductStatusData();
    hideWidget();
    viewDetailsVisible = false;
    GetProductName();

  }

  Future DeleteProductData() async{
    Map<String, String> JsonBody = {
      'Id':proid.toString(),
      'CustId': custid.toString(),
      'PDate':sdate,
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Product/DeleteCustomerProduct"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      setState(() {
        productdetailsfuture = getProductStatusData();
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product delete successfully"),
            duration: Duration(seconds: 3),
          ));

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 3),
          ));
    }

    print("DATA: ${data}");
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
      return customerList;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future GetProductName() async{
    Map<String, String> JsonBody = {
      'CompanyId':_myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Product/GetProduct"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    final json = jsonDecode(response.body)['Response'];

    // _milkman = jsonDecode(response.body)['Response'];
    setState(() {
      _productname = (json)
          .map<ProductNameModel>((item) => ProductNameModel.fromJson(item))
          .toList();
      proname = _productname[0].Product_name;
      dropproductnm = _productname[0].Id.toString() +","+_productname[0].Product_name;
      droppronmid = _productname[0].Id.toString();
      GetProductQuantity();
    });
  }

  Future GetProductQuantity() async{
    Map<String, String> JsonBody = {
      'CompanyId':_myServices.myCompanyId,
      'ProductNameId':droppronmid,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Product/GetProductDetail"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    final json = jsonDecode(response.body)['Response'];

    // _milkman = jsonDecode(response.body)['Response'];
    setState(() {
      _productqty = (json)
          .map<ProductModel>((item) => ProductModel.fromJson(item))
          .toList();

      dropproductqty = _productqty[0].Product_qty +","+_productqty[0].Product_unit+","+_productqty[0].Product_shortnm;
      dropunit =_productqty[0].Product_unit;
      dropqty =_productqty[0].Product_qty;
      droprate = _productqty[0].Product_rate.toString();
      dropproshnm = _productqty[0].Product_shortnm;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   setState(() {
  //     productdetailsfuture = getProductStatusData();
  //   });
  // }

  Future AddDeliveryStatusData() async{
    Map<String, String> JsonBody = {
      'CustId':custid.toString(),
      'CustomerName':custnm,
      'MobileNo':mobile,
      'Address':address,
      'AgentName':agentnm,
      'CowMilkQty':_coneqty.toString(),
      'CowHalfMilkQty':_chalfqty.toString(),
      'BuffalloMilkQty':_boneqty.toString(),
      'BuffalloHalfMilkQty':_bhalfqty.toString(),
      'CowMilkRate':crate.toString(),
      'BuffalloMilkRate':brate.toString(),
      'MilkStatus':"nomilk",
      'Cday':sday,
      'Cyear': syear,
      'Cmonth':smonth,
      'CDate':sdate,
      'Pin':pin,
      'CompanyId':_myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "DeliveredStatus/AddDeliveryStatus"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CalenderPage(custid)));

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 3),
          ));
    }

    print("DATA: ${data}");
  }

  Future AddDeliveryStatusMinMaxData() async{
    Map<String, String> JsonBody = {
      'CustId':custid.toString(),
      'CustomerName':custnm,
      'MobileNo':mobile,
      'Address':address,
      'AgentName':agentnm,
      'CowMilkQty':_coneqty.toString(),
      'CowHalfMilkQty':_chalfqty.toString(),
      'BuffalloMilkQty':_boneqty.toString(),
      'BuffalloHalfMilkQty':_bhalfqty.toString(),
      'CowMilkRate':crate.toString(),
      'BuffalloMilkRate':brate.toString(),
      'MilkStatus':"MinMaxMilk",
      'Cday':sday,
      'Cyear': syear,
      'Cmonth':smonth,
      'CDate':sdate,
      'Pin':pin,
      'CompanyId':_myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "DeliveredStatus/AddDeliveryStatus"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CalenderPage(custid)));

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

  Future AddProductStatusData() async{
    Map<String, String> JsonBody = {
      'CustId':custid.toString(),
      'ProductName':proname,
      'ProductQty':dropqty,
      'ProductRate':droprate,
      'ProductShortName':dropproshnm,
      'ProductUnit':dropunit,
      'ProductNameId':droppronmid,
      'AddProductStatus':"AddProduct",
      'PTotalAmt':"0",
      'PDate':sdate,
      'Cday':sday,
      'Cyear':syear,
      'Cmonth':smonth,
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Product/AddProductStatus"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      setState(() {
        productdetailsfuture = getProductStatusData();
      });
     ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product added successfully"),
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

  Future<List<ProductModel>> getProductStatusData() async{
    Map<String, String> JsonBody = {
      'CompanyId':  _myServices.myCompanyId,
      'CustId':  custid.toString(),
      'PDate':  sdate,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Product/GetProductStatusDetail"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      _productstatuslist= List< ProductModel >.from((json.decode(response.body)['Response']).map((i) => ProductModel.fromJson(i)));
      if(_productstatuslist.length == 0)
      {

      }
      else{
        showDetailsWidget();
      }

      return _productstatuslist;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width - 20,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                      child: Text("Change Quantity", style: GoogleFonts.adamina(fontSize: 20.0,color: Colors.black, fontWeight: FontWeight.bold),)),
                  Container(
                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
                    child: FutureBuilder<List<CustomerModel>>(
                      future: customerfuture,
                      builder: (context,snapshot){
                        if (snapshot.connectionState != ConnectionState.done)
                          return Center(child: CircularProgressIndicator());
                        if(snapshot.hasData){
                          List<CustomerModel> cartitem = snapshot.data;

                        }
                        return Column(
                          children: <Widget>[
                            if (cowmilk != null) Container(
                              margin: EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(width: 1.0,color: Colors.grey)
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(cowmilk,style: GoogleFonts.adamina(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 14.0),),
                                    ),
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
                                          width: 80,
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
                                                    if(_coneqty > 0)
                                                    {
                                                      _coneqty--;
                                                      ctotamt = (_coneqty * crate)+(_chalfqty * (crate/2));
                                                    }
                                                    else{

                                                    }
                                                  });
                                                },
                                                child: Icon(Icons.remove,size: 22.0,color: Colors.white,),),
                                              Text(_coneqty.toString(),style: GoogleFonts.adamina(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.bold),),
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    _coneqty++;
                                                    ctotamt = (_coneqty * crate)+(_chalfqty * (crate/2));
                                                  });
                                                },
                                                child: Icon(Icons.add,size: 22.0,color: Colors.white,),),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20.0),
                                          // color: Color(0xFF2B2B81),
                                          width: 80,
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
                                                    if(_chalfqty > 0)
                                                    {
                                                      _chalfqty--;
                                                      ctotamt = (_coneqty * crate)+(_chalfqty * (crate/2));
                                                    }
                                                    else{

                                                    }
                                                  });
                                                },
                                                child: Icon(Icons.remove,size: 22.0,color: Colors.white,),),
                                              Text(_chalfqty.toString(),style: GoogleFonts.adamina(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.bold),),
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    _chalfqty++;
                                                    ctotamt = (_coneqty * crate)+(_chalfqty * (crate/2));
                                                  });
                                                },
                                                child: Icon(Icons.add,size: 22.0,color: Colors.white,),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0,bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Rate",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          width: 80,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,  // red as border color
                                              ),
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0,top: 3.0),
                                            child: Text(crate.toString(),style: GoogleFonts.adamina(fontWeight: FontWeight.bold,fontSize: 12.0,
                                                textStyle: TextStyle(decoration: TextDecoration.none)),textAlign: TextAlign.center,),
                                          ),
                                        ),
                                        Text("TAmt",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          width: 80,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,  // red as border color
                                              ),
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                                            child: Text(ctotamt.toString(),style: GoogleFonts.adamina(fontWeight: FontWeight.bold,fontSize: 12.0),
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(buffmilk != null) Container(
                              margin: EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1.0, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(buffmilk,style: GoogleFonts.adamina(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 14.0),),
                                      )),
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
                                          width: 80,
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
                                                    if(_boneqty > 0)
                                                    {
                                                      _boneqty--;
                                                      btotamt = (_boneqty * brate)+(_bhalfqty * (brate/2));
                                                    }
                                                    else{

                                                    }
                                                  });
                                                },
                                                child: Icon(Icons.remove,size: 22.0,color: Colors.white,),),
                                              Text(_boneqty.toString(),style: GoogleFonts.adamina(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.bold),),
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    _boneqty++;
                                                    btotamt = (_boneqty * brate)+(_bhalfqty * (brate/2));
                                                  });
                                                },
                                                child: Icon(Icons.add,size: 22.0,color: Colors.white,),),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20.0),
                                          // color: Color(0xFF2B2B81),
                                          width: 80,
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
                                                    if(_bhalfqty > 0)
                                                    {
                                                      changebhalfqty = _bhalfqty;
                                                      // _bhalfqty--;
                                                      changebhalfqty--;
                                                      _bhalfqty = changebhalfqty;
                                                      btotamt = (_boneqty * brate)+(_bhalfqty * (brate/2));
                                                    }
                                                    else{

                                                    }
                                                  });
                                                },
                                                child: Icon(Icons.remove,size: 22.0,color: Colors.white,),),
                                              Text(_bhalfqty.toString(),style: GoogleFonts.adamina(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.bold),),
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    _bhalfqty++;
                                                    btotamt = (_boneqty * brate)+(_bhalfqty * (brate/2));
                                                  });
                                                },
                                                child: Icon(Icons.add,size: 22.0,color: Colors.white,),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0,bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Rate",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          width: 80,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,  // red as border color
                                              ),
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(brate.toString(),style: GoogleFonts.adamina(fontWeight: FontWeight.bold,fontSize: 12.0),),
                                          ),
                                        ),
                                        Text("TAmt",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          width: 80,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,  // red as border color
                                              ),
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                                            child: Text(btotamt.toString(),style: GoogleFonts.adamina(fontWeight: FontWeight.bold,fontSize: 12.0),
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              height: 40.0,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1.0, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Milk Status",style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.black87),),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 60.0,right: 10.0),
                                      height: 40.0,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                        child: DropdownButton<String>(
                                          value: dropdownValue,
                                          isExpanded: true,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Color(0xFF2B2B81), fontSize: 16),
                                          underline: Container(),
                                          onChanged: (String data) {
                                            setState(() {
                                              dropdownValue = data;
                                              if(dropdownValue == "No Milk"){
                                                setState(() {
                                                  _coneqty = 0;
                                                  _chalfqty = 0;
                                                  _boneqty = 0;
                                                  _bhalfqty = 0;
                                                  crate = 0;
                                                  ctotamt = 0;
                                                  brate = 0;
                                                  btotamt = 0;
                                                });

                                              }
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
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height/24,
                                      width: MediaQuery.of(context).size.width/2,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2B2B81),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ButtonTheme(
                                        minWidth: 150,
                                        height: 35,
                                        child: TextButton(
                                          onPressed: showWidget,
                                          style: TextButton.styleFrom(
                                            textStyle: TextStyle(color: Colors.white,
                                                backgroundColor: Color(0xFF2B2B81)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                          child: Text("ADD PRODUCTS",
                                              style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.white)),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: viewVisible,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1.0, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 10.0,right: 10.0),
                                      height: 30.0,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                        child: DropdownButton<String>(
                                          value: dropproductnm,
                                          isExpanded: true,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Color(0xFF2B2B81), fontSize: 16),
                                          underline: Container(),
                                          onChanged: (String data) {
                                            setState(() {
                                              dropproductnm = data;
                                              droppronmid = data.split(",")[0];
                                              proname = data.split(",")[1];
                                              GetProductQuantity();
                                            });
                                          },
                                          items: _productname.map((ProductNameModel list) {
                                            return DropdownMenuItem<String>(
                                              value: list.Id.toString() + "," + list.Product_name,
                                              child: Text(list.Product_name),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 10.0,right: 10.0),
                                      height: 30.0,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                        child: DropdownButton<String>(
                                          value: dropproductqty,
                                          isExpanded: true,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Color(0xFF2B2B81), fontSize: 16),
                                          underline: Container(),
                                          onChanged: (String data) {
                                            setState(() {
                                              dropproductqty = data;
                                              dropqty = data.split(",")[0];
                                              dropunit = data.split(",")[1];
                                              dropproshnm = data.split(",")[2];
                                            });
                                          },
                                          items: _productqty.map((ProductModel list) {
                                            return DropdownMenuItem<String>(
                                              value: list.Product_qty + "," + list.Product_unit+ "," + list.Product_shortnm,
                                              child: Text(list.Product_qty + "/" + list.Product_unit),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left:15.0),
                                            child: Text(droprate,style: GoogleFonts.adamina(fontSize: 12.0,color: Colors.black),),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(left:5.0,right: 20.0,bottom: 5.0),
                                            child: InkWell(
                                              onTap:(){
                                                if(dropdownValue == "Select")
                                                  {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text("Select MilkStatus First"),
                                                          duration: Duration(seconds: 3),
                                                        ));
                                                  }
                                                else{
                                                  EasyLoading.show(status: "Loading.....");
                                                  AddProductStatusData();
                                                }
                                              },
                                                child: Icon(Icons.add_circle,color: Color(0xFF2B2B81),size: 36.0,)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: viewDetailsVisible,
                              child: Container(
                                margin: EdgeInsets.only(top:10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0)
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top:5.0),
                                      child: Text("Product Details", style: GoogleFonts.adamina(fontSize: 14.0,fontWeight: FontWeight.bold,
                                          color: Colors.black),textAlign: TextAlign.left,),
                                    ),
                                    Container(
                                      child:
                                      FutureBuilder<List<ProductModel>>(
                                        future: productdetailsfuture,
                                        builder: (context,snapshot){
                                          if (snapshot.connectionState != ConnectionState.done)
                                            return Center(child: CircularProgressIndicator());
                                          if(snapshot.hasData){
                                            List<ProductModel> cartitem = snapshot.data;
                                          }
                                          return ListView.separated(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context, int contextIndex){
                                              return InkWell(
                                                onTap: (){
                                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalenderPage(snapshot.data[contextIndex].Id)));
                                                  // snapshot.data[contextIndex].Id.toString(),
                                                  //     snapshot.data[contextIndex].RouteName,snapshot.data[contextIndex].AgentName +" "+ snapshot.data[contextIndex].AgentId.toString())));
                                                },
                                                child: Container(
                                                  key: UniqueKey(),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              SizedBox(
                                                                  width: 90.0,
                                                                  child: Text(snapshot.data[contextIndex].Product_name,
                                                                    textAlign: TextAlign.left,
                                                                    style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87,fontWeight: FontWeight.bold),)),
                                                              SizedBox(
                                                                width: 80.0,
                                                                child: Text(snapshot.data[contextIndex].Product_qty+"/"+snapshot.data[contextIndex].Product_unit,
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87,fontWeight: FontWeight.bold),),
                                                              ),
                                                              SizedBox(
                                                                  width: 60.0,
                                                                  child: Text(snapshot.data[contextIndex].Product_rate.toString(), textAlign: TextAlign.center,
                                                                    style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87,fontWeight: FontWeight.bold),)),
                                                              SizedBox(
                                                                width: 60.0,
                                                                child: Text(snapshot.data[contextIndex].Product_shortnm, style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87,
                                                                    fontWeight: FontWeight.bold),),
                                                              ),
                                                              SizedBox(
                                                                width: 25,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(right:8.0),
                                                                  child: InkWell(
                                                                      onTap: (){
                                                                        EasyLoading.show(status: "Loading.....");
                                                                        proid = snapshot.data[contextIndex].Id;
                                                                        DeleteProductData();
                                                                      },
                                                                      child: Icon(Icons.delete_forever,size: 24.0,color: Colors.red,)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
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
                                      height: MediaQuery.of(context).size.height/24,
                                      width: MediaQuery.of(context).size.width/4,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2B2B81),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ButtonTheme(
                                        minWidth: 120,
                                        height: 40,
                                        child: TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(
                                            textStyle: TextStyle(color: Colors.white,
                                                backgroundColor: Color(0xFF2B2B81)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                          child: Text("CANCEL",
                                              style: GoogleFonts.adamina(fontSize: 16.0,color: Colors.white)),),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height/24,
                                      width: MediaQuery.of(context).size.width/4,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2B2B81),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ButtonTheme(
                                        minWidth: 120,
                                        height: 40,
                                        child: TextButton(
                                          onPressed: (){
                                            if(dropdownValue == "Select")
                                              {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text("First Select Milk Status"),
                                                      duration: Duration(seconds: 3),
                                                    ));
                                              }
                                            else{
                                              if(dropdownValue == "No Milk")
                                              {
                                                EasyLoading.show(status: "Loading.....");
                                                AddDeliveryStatusData();
                                              }
                                              else if(dropdownValue == "Add Product")
                                              {
                                                if(_productstatuslist.length == 0)
                                                {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text("Click Add Icon"),
                                                        duration: Duration(seconds: 3),
                                                      ));
                                                }
                                                else{
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CalenderPage(custid)));
                                                }
                                              }
                                              else{
                                                EasyLoading.show(status: "Loading.....");
                                                AddDeliveryStatusMinMaxData();
                                              }
                                            }

                                          },
                                          style: TextButton.styleFrom(
                                            textStyle: TextStyle(color: Colors.white,
                                                backgroundColor: Color(0xFF2B2B81)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          ),
                                          child: Text("OK",
                                              style: GoogleFonts.adamina(fontSize: 16.0,color: Colors.white)),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
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



}
