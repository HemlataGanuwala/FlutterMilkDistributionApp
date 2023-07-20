import 'dart:convert';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/milkman_list.dart';
import 'package:sizer/sizer.dart';

import '../MyServices.dart';

class AddMilkman extends StatefulWidget{
  @override
  AddmilkmanState createState() => AddmilkmanState();
}

class AddmilkmanState extends State<AddMilkman> {
  String? dropdownValue = 'Active';
  String? companyid = "";
  bool? isloading = false;

  List <String> spinnerItems = [
    'Active',
    'Deactive',
  ] ;
  bool? whatsappno1 = false;
  bool? whatsappno2 = false;
  String? whatsapp1 = "";
  String? whatsapp2 = "";

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _milkmanname = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _mobileno = TextEditingController();
  TextEditingController _email = TextEditingController();

  MyServices _myServices = new MyServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Add Milkman", style: TextStyle(
        fontSize: 16.sp
      ),),
      backgroundColor: Color(0xFF2B2B81),),
      body: Container(
        margin: EdgeInsets.only(right: 2.0.h,left: 2.0.h),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
              children: <Widget>[
                Container(
                  height: 7.h,
                  child: TextFormField(controller: _milkmanname,style: GoogleFonts.adamina(
                      color: Colors.black87,
                      fontSize: 12.0.sp
                  ),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Milkman Name',
                      prefixIcon: Visibility(
                        child: Icon(Icons.person, color: Color(0xFF2B2B81),size: 18.sp,),
                      ),
                    ),
                    validator: (String? value){
                      if(value!.isEmpty)
                      {
                        return "Please enter Milkmanname";
                      }
                      return null;
                    },
                    onSaved: (String? name){
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 7.h,
                        child: TextFormField(controller: _mobile,style: GoogleFonts.adamina(
                            color: Colors.black87,
                            fontSize: 12.0.sp
                        ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Mobile No.',
                            prefixIcon: Visibility(
                              child: Icon(Icons.phone, color: Color(0xFF2B2B81),size: 18.sp,),
                            ),
                          ),
                          validator: (String? value){
                            if(_mobileno == "")
                            {
                              if (value!.length != 10)
                                return 'Mobile Number must be of 10 digit';
                              else
                                return null;
                            }
                            return null;
                          },
                          onSaved: (String? name){
                          },
                        ),
                      ),
                    ),
                    Flexible(child: CheckboxListTile(
                        value: whatsappno1,
                      // checkColor: Colors.greenAccent,
                      onChanged: (bool? value) {
                        setState(() {
                          this.whatsappno1 = value!;
                          if(value == true)
                          {
                            whatsapp1 = "WhatsappNo";
                          }
                        });
                      },
                      contentPadding: EdgeInsets.all(0),
                        title: Text("is Whatsapp no.",
                        style: GoogleFonts.adamina(fontSize: 12.0.sp,color: Colors.black87),),
                      controlAffinity: ListTileControlAffinity.leading,
                    )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 7.h,
                        child: TextFormField(controller: _mobileno,style: GoogleFonts.adamina(
                            color: Colors.black87,
                            fontSize: 12.0.sp
                        ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Mobile No.',
                            prefixIcon: Visibility(
                              child: Icon(Icons.phone, color: Color(0xFF2B2B81),),
                            ),
                          ),
                          validator: (String? value){
                          if(_mobile == "")
                            {
                              if (value!.length != 10)
                                return 'Mobile Number must be of 10 digit';
                              else
                                return null;
                            }
                          return null;
                          },
                          onSaved: (String? name){
                          },
                        ),
                      ),
                    ),
                    Flexible(child: CheckboxListTile(
                      value: whatsappno2,
                      // checkColor: Colors.greenAccent,
                      onChanged: (bool? value) {
                        setState(() {
                          this.whatsappno2 = value!;
                          if(value == true)
                            {
                              whatsapp2 = "WhatsappNo";
                            }
                        });
                      },
                      contentPadding: EdgeInsets.all(0),
                      title: Text("is Whatsapp no.",
                        style: GoogleFonts.adamina(fontSize: 12.0.sp,color: Colors.black87),),
                      controlAffinity: ListTileControlAffinity.leading,
                    )
                    ),
                  ],
                ),
                Container(
                  height: 7.h,
                  child: TextFormField(controller: _email,style: GoogleFonts.adamina(
                      color: Colors.black87,
                      fontSize: 12.0.sp
                  ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Visibility(
                        child: Icon(Icons.email, color: Color(0xFF2B2B81),),
                      ),
                    ),
                    // validator: (String value){
                    //   // if(value.isEmpty)
                    //   // {
                    //   //   return "Please enter Email";
                    //   // }
                    //   if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                    //     return 'Please a valid Email';
                    //   }
                    //   return null;
                    // },
                    // onSaved: (String name){
                    // },
                  ),
                ),
                Container(
                  height: 7.h,
                  margin: EdgeInsets.only(top: 3.0.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 2.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: Text("Milkman Status", style: GoogleFonts.adamina(
                            color: Colors.black87,
                            fontSize: 12.0.sp,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 45,
                        width: 1,
                      ),
                      Flexible(
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Color(0xFF2B2B81), fontSize: 14.sp),
                          underline: Container(),
                          onChanged: (String? data) {
                            setState(() {
                              dropdownValue = data!;
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
                    ],
                  ),
                ),

              ],
            ),),
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 5.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: 6.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B81),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: (){
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
                            backgroundColor: Colors.transparent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text("CANCEL",
                            style: GoogleFonts.adamina(fontSize: 12.0.sp, color: Colors.white)),
                      ),),
                  ),
                  
                  Container(
                    height: 6.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B81),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: (){
                        
                        if(_formkey.currentState!.validate())
                        {
                          EasyLoading.show(status: "Loading.....");
                          AddmilkmanData();
                          print("Successful");
                        }else
                        {
                          print("Unsuccessfull");
                        }

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));

                      },
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white,
                            backgroundColor: Colors.transparent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text("SUBMIT",
                          style: GoogleFonts.adamina(fontSize: 12.0.sp, color: Colors.white)),),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: 6.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B2B81),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: (){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MilkmanList()));
                      },
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white,
                            backgroundColor: Colors.transparent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text("VIEW LIST",
                          style: GoogleFonts.adamina(fontSize: 12.0.sp, color: Colors.white)),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future AddmilkmanData() async{
    Map<String, String> JsonBody = {
      'AgentName':_milkmanname.text,
      'MobileNo':_mobile.text,
      'MobileNo1':_mobileno.text,
      'Emailid':_email.text,
      'AgentStatus':dropdownValue!,
      'WhatsappNo1':whatsapp1!,
      'WhatsappNo2':whatsapp2!,
      'CompanyId': _myServices.myCompanyId!,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl! + "Agent/AddAgent"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    if(data == 1)
    {
      EasyLoading.dismiss();
      // isLoading=!isLoading;
      isloading = false;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Milkman added successfully"),
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

}

