import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:milkdistributionflutter/model/BillModel.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/billpaycustomerlist.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../MyServices.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BillPay extends StatefulWidget {
  String custid;
  BillPay(this.custid);
  @override
  State<StatefulWidget> createState() {
    return BillPayState(custid);
  }
}

class BillPayState extends State<BillPay> {
  String custid;
  BillPayState(this.custid);
  

  MyServices _myServices = MyServices();
  Future<List<BillModel>>? billfuture;
  List<BillModel>? billList;
  bool? loading = false;
  RenderBox? box;
  ScreenshotController screenshotController = ScreenshotController();

  String? cowmilk = "", buffmilk = "", oldbal = "", cmonth = "", cyear = "",
  _receipt="",_billdt = "",_mobile="",_address = "",
  _month="",_year = "",_cowliter="",_buffliter = "",_custname = "",_balanceamt= "";
  int? coneqty = 0, chalfqty = 0, boneqty = 0, bhalfqty = 0;
  double? totamt = 0;

  TextEditingController _paidamt = TextEditingController();
 

  DateTime currdt = DateTime.now();

  @override
  void initState() {
    super.initState();
    cmonth = (currdt.month - 1).toString();
    var prevMonth = new DateTime(currdt.year, currdt.month - 1, currdt.day);
    cmonth = DateFormat("MMMM").format(prevMonth).toString();
    cyear = (currdt.year).toString();
    EasyLoading.show(status: "Loading.....");
    getBillData();
    
  }

  Future getBillData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId!,
      'CustId': custid.toString(),
      'Cmonth': cmonth!,
      'Cyear': cyear!,
    };
    var response = await http.post(
        Uri.parse(_myServices.myUrl! + "Bill/BillFormateAdminData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
        var data = jsonDecode(response.body)['Status'];
    var responsedata = jsonDecode(response.body)['Response'];
    if (data == 1) {
      EasyLoading.dismiss();
      setState(() {
        _receipt = responsedata[0]["Id"].toString();
        _billdt = responsedata[0]["CDate"];
        _custname = responsedata[0]["CustomerName"];
        _mobile = responsedata[0]["MobileNo"];
        _address = responsedata[0]["Address"];
        _month = responsedata[0]["Cmonth"];
        _year = responsedata[0]["Cyear"];
        totamt = responsedata[0]["GrandTotal"];        
        cowmilk = responsedata[0]["CowMilk"];
        cowmilk = "Cow";
        buffmilk = responsedata[0]["BuffaloMilk"];
        buffmilk = "Buff";
          coneqty = responsedata[0]["CowMilkQty"];
        chalfqty = responsedata[0]["CowHalfMilkQty"];
        _cowliter = (coneqty! + chalfqty! * 0.5).toString();
        
        boneqty = responsedata[0]["BuffalloMilkQty"];
        bhalfqty = responsedata[0]["BuffalloHalfMilkQty"];
        _buffliter = (boneqty! + bhalfqty! * 0.5).toString();
        oldbal = responsedata[0]["OldBalance"];
      });

    }    
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future PaidData() async{
    loading = true;
    Map<String, String> JsonBody = {      
      'CustId':custid.toString(),    
      'PaidAmt':_paidamt.text, 
      'OldBalance':_balanceamt!,             
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl! + "Bill/PaidBill"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.show(status: "Loading.....");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Paid successfully"),
            duration: Duration(seconds: 3),
          )); 
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillPayCustomerList()));

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

  

  Future screenToPdf(String fileName,Uint8List screenShot) async {
  pw.Document pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Expanded(
          child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain),
        );
      },
    ),
  );
  String path = (await getTemporaryDirectory()).path;
  File pdfFile = await File('$path/$fileName.pdf').create();

  pdfFile.writeAsBytesSync(await pdf.save());
  await Share.shareFiles([pdfFile.path],
  subject: "subject",
  sharePositionOrigin: box!.localToGlobal(Offset(0, 0)) & box!.size,);
}

shareImage() async {

    final uint8List = await screenshotController.capture();
    String tempPath = (await getTemporaryDirectory()).path;
    String fileName ="myFile";
    if (await Permission.storage.request().isGranted) {
      File file = await File('$tempPath/$fileName.png').create();
      file.writeAsBytesSync(uint8List!);
      await Share.shareFiles([file.path],
  subject: "subject",
  sharePositionOrigin: box!.localToGlobal(Offset(0, 0)) & box!.size,);
      //await Share.shareFiles([file.path]);
      //screenToPdf(fileName,uint8List);
    }
  }

  @override
  Widget build(BuildContext context) { 
    box = context.findRenderObject() as RenderBox;   
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Billing Customer List")),
        backgroundColor: Color(0xFF2B2B81),
        actions: <Widget>[
    IconButton(
      icon: Icon(
        Icons.picture_as_pdf,
        color: Colors.white,
      ),
      onPressed: () {
        // do something
        shareImage();
      },
    )
  ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
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
                    border: Border.all(width: 1.0, color: Colors.blue[800]!)),
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
                                color: Colors.green[800]!, offset: Offset(0, -10))
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
                                _receipt!,
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
                                _billdt!,
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
                                              _custname!,
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
                                              _mobile!,
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
                                              _address!,
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
                                // height: 50.0,
      
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            cowmilk! + ":",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.indigo[800],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 40.0,
                                            child: Text(
                                              _cowliter!,
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
                                            buffmilk! + ":",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.indigo[800],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 40.0,
                                            child: Text(
                                              _cowliter!,
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
                                _month!,
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
                                _year!,
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
                          totamt.toString(),
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
                        'Previous Balance:',
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
                          oldbal!,
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
                        child: TextField(
                          controller: _paidamt,
                          onChanged: (value) {
                            if(value == "")
                            {
                              value = "0.0";
                            }
                            setState(() {
                              _balanceamt = (totamt! - double.parse(value)).toString();
                            });
                            
                          },
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
                        'Balance Amount:',
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
                          _balanceamt!,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ),
              //Button
              Container(
                margin: EdgeInsets.only(top: 30.0),
                      height: MediaQuery.of(context).size.height/24,
                        width: MediaQuery.of(context).size.width/2,
                        decoration: BoxDecoration(
                          color: Color(0xFF2B2B81),
                          borderRadius: BorderRadius.circular(12),
                        ),
                       child: ButtonTheme(
                         minWidth: 150,
                         height: 40,
                         child: TextButton(
                           onPressed: (){
                             if(_paidamt.text == "")
                             {
                              Fluttertoast.showToast(
                                msg: "Enter Paid Amount First",
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
                              PaidData();
                             }
                           },
                           style: TextButton.styleFrom(
                             textStyle: TextStyle(color: Colors.white,
                                 backgroundColor: Color(0xFF2B2B81)),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                           ),
                           child: Text("Pay",
                               style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.white,
                               fontWeight: FontWeight.bold)),),
                       ),
                   ),
            ],
          ),
        ),
      ),
    );
  }
}
