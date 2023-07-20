import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/model/ProductModel.dart';
import 'package:milkdistributionflutter/model/ProductNameModel.dart';
import 'package:sizer/sizer.dart';

import '../MyServices.dart';

class AddProduct extends StatefulWidget {
  @override
  AddproductState createState() => AddproductState();
}

class AddproductState extends State<AddProduct> {
  String dropdownValue = 'gm';
  MyServices _myServices = new MyServices();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _pronamecontroller = TextEditingController();
  TextEditingController _proqtycontroller = TextEditingController();
  TextEditingController _proratecontroller = TextEditingController();
  TextEditingController _proshoetnmcontroller = TextEditingController();
  TextEditingController _prounitcontroller = TextEditingController();
  TextEditingController _proIDcontroller = TextEditingController();
  bool loading = false;
  Future<List<ProductModel>>? productfuture;
  List<ProductModel>? productList;
  List<ProductNameModel>? _productname;
  int proid = 0, productnameid = 0;
  String? productid;
  bool editbtn = false;
  bool addbtn = true;

  List<String> spinnerItems = [
    'gm',
    'kg',
    'ltr',
    'qty',
    'bottle',
    'dozen',
  ];

  @override
  void initState() {
    super.initState();
    GetProductName();
    setState(() {
      productfuture = getProductData();
    });
  }

  void navigateToAddProduct() async {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => AddProduct()))
        .whenComplete(() {
      setState(() {
        getProductData();
      });
    });
  }

  Future AddProductData() async {
    Map<String, String> JsonBody = {
      'ProductName': _pronamecontroller.text,
      'ProductQty': _proqtycontroller.text,
      'ProductRate': _proratecontroller.text,
      'ProductShortName': _proshoetnmcontroller.text,
      'ProductUnit': dropdownValue,
      'ProductNameId': _proIDcontroller.text,
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Product/AddProducts"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if (data == 1) {
      EasyLoading.dismiss();
      setState(() {
        navigateToAddProduct();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Product added successfully"),
        duration: Duration(seconds: 3),
      ));

      _pronamecontroller.text = "";
      _proqtycontroller.text = "";
      _proratecontroller.text = "";
      _proshoetnmcontroller.text = "";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ));
    }

    print("DATA: ${data}");
  }

  Future EditProductData() async {
    Map<String, String> JsonBody = {
      'Id': productid!,
      'ProductName': _pronamecontroller.text,
      'ProductQty': _proqtycontroller.text,
      'ProductRate': _proratecontroller.text,
      'ProductShortName': _proshoetnmcontroller.text,
      'ProductUnit': dropdownValue,
      'ProductNameId': productnameid.toString(),
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Product/EditProducts"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if (data == 1) {
      EasyLoading.dismiss();
      setState(() {
        navigateToAddProduct();
      });

      setState(() {
        addbtn = true;
        editbtn = false;
        if (addbtn == true) AddButton();
      });

      // isLoading=!isLoading;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Product edited successfully"),
        duration: Duration(seconds: 3),
      ));

      _pronamecontroller.text = "";
      _proqtycontroller.text = "";
      _proratecontroller.text = "";
      _proshoetnmcontroller.text = "";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ));
    }

    print("DATA: ${data}");
  }

  Future DeleteProductData() async {
    Map<String, String> JsonBody = {
      'Id': proid.toString(),
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Product/DeleteProduct"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if (data == 1) {
      EasyLoading.dismiss();
      setState(() {
        navigateToAddProduct();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Product delete successfully"),
        duration: Duration(seconds: 3),
      ));

      _pronamecontroller.text = "";
      _proqtycontroller.text = "";
      _proratecontroller.text = "";
      _proshoetnmcontroller.text = "";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ));
    }

    print("DATA: ${data}");
  }

  Future<List<ProductModel>> getProductData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Product/GetProduct"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      productList = List<ProductModel>.from(
          (json.decode(response.body)['Response'])
              .map((i) => ProductModel.fromJson(i))).toList();
      return productList!;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future GetProductName() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Product/GetProductName"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    final json = jsonDecode(response.body)['Response'];

    // _milkman = jsonDecode(response.body)['Response'];
    setState(() {
      _productname = (json)
          .map<ProductNameModel>((item) => ProductNameModel.fromJson(item))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Products"),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Container(
        margin: EdgeInsets.only(right: 10.0, left: 10.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Autocomplete<ProductNameModel>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == null ||
                          textEditingValue.text == '') {
                        return const Iterable<ProductNameModel>.empty();
                      }
                      return _productname!.where((ProductNameModel option) {
                        return option.Product_name!.toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (ProductNameModel selection) {
                      print('Selected: ${selection.Product_name}');
                    },
                    displayStringForOption: (ProductNameModel option) =>
                        option.Product_name!,
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      _pronamecontroller = textEditingController;
                      return TextFormField(
                        controller: _pronamecontroller,
                        style: GoogleFonts.adamina(
                            color: Colors.black87, fontSize: 14.0),
                        decoration: InputDecoration(
                          hintText: 'Product Name',
                        ),
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Please enter Product Name";
                          }
                          return null;
                        },
                        onSaved: (String? name) {},
                        focusNode: focusNode,
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<ProductNameModel> onSelected,
                        Iterable<ProductNameModel> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            height: 200.0,
                            child: ListView.builder(
                              padding: EdgeInsets.all(8.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final ProductNameModel option =
                                    options.elementAt(index);
                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text(
                                        option.Product_name!,
                                        style: GoogleFonts.adamina(
                                            color: Colors.black87,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: _proqtycontroller,
                          style: GoogleFonts.adamina(
                              color: Colors.black87, fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Product Quantity',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Please enter Product Quantity";
                            }
                            return null;
                          },
                          onSaved: (String? name) {},
                        ),
                      ),
                      Container(
                        height: 40.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Color(0xFF2B2B81), fontSize: 18),
                              underline: Container(),
                              onChanged: (String? data) {
                                setState(() {
                                  dropdownValue = data!;
                                });
                              },
                              items: spinnerItems.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: _proratecontroller,
                          style: GoogleFonts.adamina(
                              color: Colors.black87, fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Product Rate',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Please enter Product Rate";
                            }
                            return null;
                          },
                          onSaved: (String? name) {},
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _proshoetnmcontroller,
                    style: GoogleFonts.adamina(
                        color: Colors.black87, fontSize: 14.0),
                    decoration: InputDecoration(
                      hintText: 'Product Short Name',
                    ),
                  ),
                ],
              ),
            ),
            addbtn ? AddButton() : EditButton(),
            Divider(
              thickness: 1.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      width: 90.0,
                      child: Text(
                        "Name",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.adamina(
                            fontSize: 14.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    width: 80.0,
                    child: Text(
                      "Quantity",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.adamina(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                      width: 60.0,
                      child: Text(
                        "Rate",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.adamina(
                            fontSize: 14.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    width: 60.0,
                    child: Text(
                      "Short Name",
                      style: GoogleFonts.adamina(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
            ),
            Container(
              child: FutureBuilder<List<ProductModel>>(
                future: productfuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasData) {
                    List<ProductModel>? cartitem = snapshot.data;
                  }
                  return (productList != null)
                      ? ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder:
                              (BuildContext context, int contextIndex) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  addbtn = false;
                                  editbtn = true;
                                  if (editbtn == true) EditButton();
                                });

                                String productnm =
                                    snapshot.data![contextIndex].Product_name!;
                                String productqty =
                                    snapshot.data![contextIndex].Product_qty!;
                                String productrate = snapshot
                                    .data![contextIndex].Product_rate
                                    .toString();
                                String productunit =
                                    snapshot.data![contextIndex].Product_unit!;
                                String productsh =
                                    snapshot.data![contextIndex].Product_shortnm!;
                                productid =
                                    snapshot.data![contextIndex].Id.toString();
                                productnameid =
                                    snapshot.data![contextIndex].Product_Name_Id!;

                                _pronamecontroller.text = productnm;
                                _proqtycontroller.text = productqty;
                                _proratecontroller.text = productrate;
                                // _prounitcontroller.text = productunit;
                                _proshoetnmcontroller.text = productsh;
                                dropdownValue = productunit;
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                        width: 90.0,
                                        child: Text(
                                          snapshot
                                              .data![contextIndex].Product_name!,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.adamina(
                                              fontSize: 14.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      width: 80.0,
                                      child: Text(
                                        snapshot.data![contextIndex]
                                                .Product_qty! +
                                            "/" +
                                            snapshot.data![contextIndex]
                                                .Product_unit!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.adamina(
                                            fontSize: 14.0,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                        width: 60.0,
                                        child: Text(
                                          snapshot
                                              .data![contextIndex].Product_rate
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.adamina(
                                              fontSize: 14.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      width: 60.0,
                                      child: Text(
                                        snapshot
                                            .data![contextIndex].Product_shortnm!,
                                        style: GoogleFonts.adamina(
                                            fontSize: 14.0,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: InkWell(
                                            onTap: () {
                                              proid = snapshot
                                                  .data![contextIndex].Id!;
                                                  EasyLoading.show(status: "Loading.....");
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
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        )
                      : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget AddButton() {
    return Visibility(
      visible: addbtn,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width / 3.8,
          decoration: BoxDecoration(
            color: Color(0xFF2B2B81),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ButtonTheme(
            minWidth: 100,
            height: 35,
            child: TextButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  EasyLoading.show(status: "Loading.....");
                  AddProductData();
                  print("Successful");
                } else {
                  print("Unsuccessfull");
                }
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                    color: Colors.white, backgroundColor: Color(0xFF2B2B81)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text("ADD",
                  style: GoogleFonts.adamina(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget EditButton() {
    return Visibility(
      visible: editbtn,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width / 3.8,
          decoration: BoxDecoration(
            color: Color(0xFF2B2B81),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ButtonTheme(
            minWidth: 100,
            height: 35,
            child: TextButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  EasyLoading.show(status: "Loading....");
                  EditProductData();
                  print("Successful");
                } else {
                  print("Unsuccessfull");
                }
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                    color: Colors.white, backgroundColor: Color(0xFF2B2B81)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text("EDIT",
                  style: GoogleFonts.adamina(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
