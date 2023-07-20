import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/buyer/buyercalender.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../MyServices.dart';
// import 'calender.dart';

class BuyerPlanVaccation extends StatefulWidget{

int plancustid;
BuyerPlanVaccation(this.plancustid);

  @override
  State<StatefulWidget> createState() {
    return BuyerPlanVaccationState(plancustid);
  }

}

class BuyerPlanVaccationState extends State<BuyerPlanVaccation> {
  int custid;
  BuyerPlanVaccationState(this.custid);
MyServices _myServices = new MyServices();
TextEditingController textControllerFromDate = new TextEditingController();
TextEditingController textControllerToDate = new TextEditingController();
String plantodate,planfromdate;
bool loading = false;

DateTime fromDate = DateTime.now();
DateTime toDate = DateTime.now();

Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != fromDate)
      setState(() {
        fromDate = picked;
        String convertedDateTime = "${picked.day.toString()}-${picked.month.toString().padLeft(2,'0')}-${picked.year.toString().padLeft(2,'0')}";
        planfromdate = "${picked.year.toString()}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}";
       // widget.textController.value = TextEditingValue(text: picked.toString());
        textControllerFromDate.value = TextEditingValue(text: convertedDateTime);;
      });
  }

Future<Null> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != toDate)
      setState(() {
        toDate = picked;
        String convertedDateTime = "${picked.day.toString()}-${picked.month.toString().padLeft(2,'0')}-${picked.year.toString().padLeft(2,'0')}";
        plantodate = "${picked.year.toString()}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}";
       // widget.textController.value = TextEditingValue(text: picked.toString());
        textControllerToDate.value = TextEditingValue(text: convertedDateTime);
      });
  }

  Future AddPlanVaccationData() async{
    loading = true;
    Map<String, String> JsonBody = {
      'FromDate':planfromdate,
      'ToDate':plantodate,
      'CustId':custid.toString(),    
      'CowMilkQty':"0.0", 
      'CowHalfMilkQty':"0.0", 
      'CowMilkRate':"0.0", 
      'BuffalloMilkQty':"0.0", 
      'BuffalloHalfMilkQty':"0.0", 
      'BuffalloMilkRate':"0.0", 
      'MilkStatus':"nomilk",  
      'TotalAmt':"0.0",         
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "DeliveredStatus/AddVacationDeliveryStatus"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      loading = false;
      // isLoading=!isLoading;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Added successfully"),
            duration: Duration(seconds: 3),
          )); 
          
          Navigator.push(context,MaterialPageRoute(builder: (context) => BuyerCalenderPage(custid)));

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
                  Padding(
                    padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 15.0),
                    child: Container(
                      child: Text("Select Date From and To",
                      style: TextStyle(fontSize: 16.0, color: Color(0xFF2B2B81)),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                    onTap: () => _selectFromDate(context),
                    child: AbsorbPointer(
                      child: Container(
                        height: MediaQuery.of(context).size.height/16,
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
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                            // pass the hint text parameter here
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                            suffixIcon: Icon(
                                Icons.calendar_today, color: Color(0xFF2B2B81),),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:12.0, right: 12.0, bottom: 6.0),
                    child: GestureDetector(
                    onTap: () => _selectToDate(context),
                    child: AbsorbPointer(
                      child: Container(   
                        height: MediaQuery.of(context).size.height/16,                   
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 2.0, color: Colors.grey[200]),
                        ),
                        child: TextField(                        
                          controller: textControllerToDate,                  
                          decoration: InputDecoration(                        
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),                            
                            labelText: "To Date",
                            labelStyle: TextStyle(                              
                                color: Colors.black,
                                fontSize: 14),
                            // pass the hint text parameter here
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14),
                            suffixIcon: Icon(
                                Icons.calendar_today, color: Color(0xFF2B2B81),),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:12.0, right: 12.0,top: 10.0, bottom: 15.0),
                    child: Container(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 Container(
                    height: MediaQuery.of(context).size.height/24,
                      width: MediaQuery.of(context).size.width/4,
                      decoration: BoxDecoration(
                        color: Color(0xFF2B2B81),
                        borderRadius: BorderRadius.circular(12),
                      ),
                     child: ButtonTheme(
                       minWidth: 150,
                       height: 40,
                       child: TextButton(
                         onPressed: (){
                          Navigator.pop(context);
                           // if(_formkey.currentState.validate())
                           // {
                           //   // RegistrationUser();
                           //   print("Successful");
                           // }else
                           // {
                           //   print("Unsuccessfull");
                           // }
                         },
                         style: TextButton.styleFrom(
                           textStyle: TextStyle(color: Colors.white,
                               backgroundColor: Color(0xFF2B2B81)),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                         ),
                         child: Text("CANCLE",
                             style: GoogleFonts.adamina(fontSize: 12.0,color: Colors.white)),),
                     ),
                 ),
                 Container(
                    height: MediaQuery.of(context).size.height/24,
                      width: MediaQuery.of(context).size.width/4,
                      decoration: BoxDecoration(
                        color: Color(0xFF2B2B81),
                        borderRadius: BorderRadius.circular(12),
                      ),
                     child: ButtonTheme(
                       minWidth: 150,
                       height: 40,
                       child: TextButton(
                         onPressed: (){
                           if(textControllerFromDate.text == ""){
                              Fluttertoast.showToast(
                              msg: "Select FromDate First",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                                return;
                           }
                           else if(textControllerToDate.text == ""){
                             Fluttertoast.showToast(
                              msg: "Select ToDate First",
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
                            AddPlanVaccationData();
                           }
                         },
                         style: TextButton.styleFrom(
                           textStyle: TextStyle(color: Colors.white,
                               backgroundColor: Color(0xFF2B2B81)),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                         ),
                         child: Text("OK",
                             style: GoogleFonts.adamina(fontSize: 12.0,color: Colors.white)),),
                     ),
                 ),                 
               ],
             ),
           ),
                  ),
                ]
                ),
          ),
          )
          ),
    ),

   );
  }
}