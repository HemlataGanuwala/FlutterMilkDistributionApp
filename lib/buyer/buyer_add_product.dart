import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/buyer/buyercalender.dart';
import 'package:milkdistributionflutter/model/ProductModel.dart';
import 'package:milkdistributionflutter/model/ProductNameModel.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../MyServices.dart';
// import 'calender.dart';

class BuyerAddProduct extends StatefulWidget {
  int plancustid;
  BuyerAddProduct(this.plancustid);

  @override
  State<StatefulWidget> createState() {
    return BuyerAddProductState(plancustid);
  }
}

class BuyerAddProductState extends State<BuyerAddProduct> {
  int custid, proid;
  BuyerAddProductState(this.custid);
  MyServices _myServices = new MyServices();
  TextEditingController textControllerFromDate = new TextEditingController();
  TextEditingController textControllerToDate = new TextEditingController();
  String plantodate, planfromdate;
  bool loading = false;
  bool viewVisible = false;
  bool viewDetailsVisible = false;
  Future<List<ProductModel>> productdetailsfuture;
  List<ProductNameModel> _productname;
  List<ProductModel> _productqty;
  List<ProductModel> _productstatuslist;
  String dropproductnm,
      dropproductqty,
      droppronmid,
      droprate = "",
      dropproshnm = "",
      dropprounit,
      proname,
      dropqty,
      dropunit;
  String sday, smonth, syear;
  DateTime fromDate = DateTime.now();
  DateTime currentdate;

  @override
  void initState() {
    super.initState();
    productdetailsfuture = getProductStatusData();
    currentdate = DateTime.now();    
    textControllerFromDate.text = fromDate.day.toString() +
        "/" +
        fromDate.month.toString() +
        "/" +
        fromDate.year.toString();
        sday = fromDate.day.toString();
        smonth = fromDate.month.toString();
        syear = fromDate.year.toString();
    viewDetailsVisible = false;
    GetProductName();
  }

  void showDetailsWidget() {
    setState(() {
      viewDetailsVisible = true;
    });
  }

  void hideDetailsWidget() {
    setState(() {
      viewDetailsVisible = false;
    });
  }

  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != fromDate)
      setState(() {
        fromDate = picked;
        String convertedDateTime =
            "${picked.day.toString()}/${picked.month.toString()}/${picked.year.toString()}";
        planfromdate =
            "${picked.year.toString()}/${picked.month.toString()}/${picked.day.toString()}";
        // widget.textController.value = TextEditingValue(text: picked.toString());
        textControllerFromDate.value =
            TextEditingValue(text: convertedDateTime);
        sday = picked.day.toString();
        smonth = picked.month.toString();
        syear = picked.year.toString();
      });
  }

  Future DeleteProductData() async {
    Map<String, String> JsonBody = {
      'Id': proid.toString(),
      'CustId': custid.toString(),
      'PDate': textControllerFromDate.text,
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Product/DeleteCustomerProduct"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if (data == 1) {
      setState(() {
        productdetailsfuture = getProductStatusData();       
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Product delete successfully"),
        duration: Duration(seconds: 3),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ));
    }

    print("DATA: ${data}");
  }

  Future<List<ProductModel>> getProductStatusData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId,
      'CustId': custid.toString(),
      'PDate': textControllerFromDate.text,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Product/GetProductStatusDetail"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      _productstatuslist = List<ProductModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => ProductModel.fromJson(i)));
      if (_productstatuslist.length == 0) {
        hideDetailsWidget();
      } else {
        showDetailsWidget();
      }

      return _productstatuslist;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future GetProductName() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Product/GetProduct"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    final json = jsonDecode(response.body)['Response'];

    // _milkman = jsonDecode(response.body)['Response'];
    setState(() {
      _productname = (json)
          .map<ProductNameModel>((item) => ProductNameModel.fromJson(item))
          .toList();
      proname = _productname[0].Product_name;
      dropproductnm =
          _productname[0].Id.toString() + "," + _productname[0].Product_name;
      droppronmid = _productname[0].Id.toString();
      GetProductQuantity();
    });
  }

  Future GetProductQuantity() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId,
      'ProductNameId': droppronmid,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Product/GetProductDetail"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    final json = jsonDecode(response.body)['Response'];

    // _milkman = jsonDecode(response.body)['Response'];
    setState(() {
      _productqty = (json)
          .map<ProductModel>((item) => ProductModel.fromJson(item))
          .toList();

      dropproductqty = _productqty[0].Product_qty +
          "," +
          _productqty[0].Product_unit +
          "," +
          _productqty[0].Product_shortnm;
      dropunit = _productqty[0].Product_unit;
      dropqty = _productqty[0].Product_qty;
      droprate = _productqty[0].Product_rate.toString();
      dropproshnm = _productqty[0].Product_shortnm;
    });
  }

  Future AddProductStatusData() async {
    Map<String, String> JsonBody = {
      'CustId': custid.toString(),
      'ProductName': proname,
      'ProductQty': dropqty,
      'ProductRate': droprate,
      'ProductShortName': dropproshnm,
      'ProductUnit': dropunit,
      'ProductNameId': droppronmid,
      'AddProductStatus': "AddProduct",
      'PTotalAmt': "0",
      'PDate': textControllerFromDate.text,
      'Cday': sday,
      'Cyear': syear,
      'Cmonth': smonth,
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl + "Product/AddProductStatus"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if (data == 1) {
      setState(() {
        productdetailsfuture = getProductStatusData();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Product added successfully"),
        duration: Duration(seconds: 3),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            width: MediaQuery.of(context).size.width - 60,            
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () => _selectFromDate(context),
                  child: AbsorbPointer(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 2.0, color: Colors.grey[200]),
                      ),
                      child: TextField(
                        controller: textControllerFromDate,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "From Date",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 14),
                          // pass the hint text parameter here
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 14),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF2B2B81),
                          ),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                width: MediaQuery.of(context).size.width,                
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: Text("Product")),
                              Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                height: 30.0,
                                width: MediaQuery.of(context).size.width / 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: DropdownButton<String>(
                                    value: dropproductnm,
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Color(0xFF2B2B81), fontSize: 16),
                                    underline: Container(),
                                    onChanged: (String data) {
                                      setState(() {
                                        dropproductnm = data;
                                        droppronmid = data.split(",")[0];
                                        proname = data.split(",")[1];
                                        GetProductQuantity();
                                      });
                                    },
                                    items: _productname
                                        .map((ProductNameModel list) {
                                      return DropdownMenuItem<String>(
                                        value: list.Id.toString() +
                                            "," +
                                            list.Product_name,
                                        child: Text(list.Product_name),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: Text("Quantity")),
                              Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                height: 30.0,
                                width: MediaQuery.of(context).size.width / 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: DropdownButton<String>(
                                    value: dropproductqty,
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Color(0xFF2B2B81), fontSize: 16),
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
                                        value: list.Product_qty +
                                            "," +
                                            list.Product_unit +
                                            "," +
                                            list.Product_shortnm,
                                        child: Text(list.Product_qty +
                                            "/" +
                                            list.Product_unit),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text("Rate :")),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    droprate,
                                    style: GoogleFonts.adamina(
                                        fontSize: 12.0, color: Colors.black),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 20.0, bottom: 5.0),
                                  child: InkWell(
                                      onTap: () {
                                        AddProductStatusData();
                                      },
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Color(0xFF2B2B81),
                                        size: 36.0,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),                    
                  ],
                ),
              ),
              ProductDetails(),
              Buttons(),
            ]),
          ),
        )),
      ),
    );
  }

  Widget ProductDetails() {
    return Visibility(
      visible: viewDetailsVisible,
      child: Container(          
          width: MediaQuery.of(context).size.width,  
          //height: MediaQuery.of(context).size.height,           
          margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(5.0)),
          child: Column(
            children: <Widget>[
              Container(              
                height: 20.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Product Details",
                    style: GoogleFonts.adamina(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(                    
                alignment: Alignment.topLeft,            
                child: FutureBuilder<List<ProductModel>>(
                  future: productdetailsfuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.hasData) {
                      List<ProductModel> cartitem = snapshot.data;
                    }
                    return ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int contextIndex) {
                        return InkWell(
                          onTap: () {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                            width: 80.0,
                                            child: Text(
                                              snapshot.data[contextIndex]
                                                  .Product_name,
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.adamina(
                                                  fontSize: 12.0,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        SizedBox(
                                          width: 70.0,
                                          child: Text(
                                            snapshot.data[contextIndex]
                                                    .Product_qty +
                                                "/" +
                                                snapshot.data[contextIndex]
                                                    .Product_unit,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.adamina(
                                                fontSize: 12.0,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                            width: 60.0,
                                            child: Text(
                                              snapshot
                                                  .data[contextIndex].Product_rate
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.adamina(
                                                  fontSize: 12.0,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        // SizedBox(
                                        //   width: 60.0,
                                        //   child: Text(
                                        //     snapshot.data[contextIndex]
                                        //         .Product_shortnm,
                                        //     style: GoogleFonts.adamina(
                                        //         fontSize: 14.0,
                                        //         color: Colors.black87,
                                        //         fontWeight: FontWeight.bold),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: 25,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8.0),
                                            child: InkWell(
                                                onTap: () {
                                                  proid = snapshot
                                                      .data[contextIndex].Id;
                                                  DeleteProductData();
                                                },
                                                child: Icon(
                                                  Icons.delete_forever,
                                                  size: 24.0,
                                                  color: Colors.red,
                                                )),
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
      
    );
  }

  Widget Buttons() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, top: 10.0, bottom: 15.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 24,
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                color: Color(0xFF2B2B81),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ButtonTheme(
                minWidth: 150,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);                    
                  },
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        color: Colors.white,
                        backgroundColor: Color(0xFF2B2B81)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("CANCLE",
                      style: GoogleFonts.adamina(
                          fontSize: 12.0, color: Colors.white)),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 24,
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                color: Color(0xFF2B2B81),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ButtonTheme(
                minWidth: 150,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    var d1 = (fromDate.year+fromDate.month+fromDate.day);
                    var d2 = (currentdate.year+currentdate.month+currentdate.day);
                    if(d1 <= d2){
                      Fluttertoast.showToast(
                          msg: "Product not added on previous and current day",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }else{
                      if (_productstatuslist.length == 0){                      
                        Fluttertoast.showToast(
                          msg: "First Add Product",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerCalenderPage(custid)));
                    }
                    }
                    
                    
                  },
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        color: Colors.white,
                        backgroundColor: Color(0xFF2B2B81)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("OK",
                      style: GoogleFonts.adamina(
                          fontSize: 12.0, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
