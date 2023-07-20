import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/Reg.dart';
import 'package:milkdistributionflutter/buildInputDecoration.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:milkdistributionflutter/seller/start_main_page.dart';

import 'DatabaseHelper.dart';
import 'seller/Loginpage.dart';
import 'package:sizer/sizer.dart';

class CompanyRegistration extends StatefulWidget{
  @override
  _CompanyRegistrationPageState createState() => _CompanyRegistrationPageState();

}

class _CompanyRegistrationPageState extends State<CompanyRegistration>{

  TextEditingController _comp_name = TextEditingController();
  TextEditingController _mobileno = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _city = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MyServices _myServices = new MyServices();
  late Reg _reg;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 6.0.h),
                child: Text("Registration", style: GoogleFonts.adamina(color: Colors.black,fontSize: 18.0.sp,decoration: TextDecoration.none),
                  textAlign: TextAlign.center,),
              ),
              Form(
                key: _formkey,
                  child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(3.0.w),
                  child: Container(
                    margin: EdgeInsets.only(top: 6.0.h),
                    height: 7.0.h,
                    child: TextFormField(controller: _comp_name,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: TextInputType.name,
                      decoration:buildInputDecoration(FontAwesomeIcons.user,"Company Name"),
                      validator: (String? value){
                        if(value!.isEmpty)
                        {
                          return "Please enter name";
                        }
                        return null;
                      },
                      onSaved: (String? name){
                      },
                    ),
                  ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0),
                    child: Container(
                      height: 7.0.h,
                      child: TextFormField(controller: _mobileno,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.phone,
                        decoration:buildInputDecoration(FontAwesomeIcons.mobileAlt,"Mobile No."),
                        validator: (String? value){
                          if (value!.length != 10)
                            return 'Mobile Number must be of 10 digit';
                          else
                            return null;
                        },
                        onSaved: (String? name){
                        },),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0),
                    child: Container(
                      height: 7.0.h,
                      child: TextFormField(controller: _address,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.streetAddress,
                        decoration:buildInputDecoration(FontAwesomeIcons.addressBook,"Address"),
                        validator: (String? value){
                          if(value!.isEmpty)
                          {
                            return "Please enter Address";
                          }
                          return null;
                        },
                        onSaved: (String? name){
                        },),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0),
                    child: Container(
                      height: 7.0.h,
                      child: TextFormField(controller: _email,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.emailAddress,
                        decoration:buildInputDecoration(FontAwesomeIcons.envelope,"Email"),
                        validator: (String? value){
                          if(value!.isEmpty)
                          {
                            return "Please enter Email";
                          }
                          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                            return 'Please a valid Email';
                          }
                          return null;
                        },
                        onSaved: (String? name){
                        },),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0),
                    child: Container(
                      height: 7.0.h,
                      child: TextFormField(controller: _password,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.visiblePassword,
                        decoration:buildInputDecoration(FontAwesomeIcons.unlock,"Password"),
                        validator: (String? value){
                          if(value!.length != 6)
                          {
                            return "Please enter 6 digit Password";
                          }
                          return null;
                        },
                        onSaved: (String? name){
                        },),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0),
                    child: Container(
                      height: 7.0.h,
                      child: TextFormField(controller: _city,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                        decoration:buildInputDecoration(FontAwesomeIcons.city,"City"),
                        validator: (String? value){
                          if(value!.isEmpty)
                          {
                            return "Please enter city";
                          }
                          return null;
                        },
                        onSaved: (String? name){
                        },),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 6.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: Color(0xFF2B2B81),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: (){
                          if(_formkey.currentState!.validate())
                          {
                            RegistrationUser();
                            print("Successful");
                          }else
                          {
                            print("Unsuccessfull");
                          }
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(backgroundColor: Colors.transparent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text("REGISTER",
                            style: GoogleFonts.adamina(fontSize: 14.0, color: Colors.white)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4.0.h),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Loginpage()));
                      },
                      child: RichText(
                        text: TextSpan(
                            text: "Already have account?",
                            style: GoogleFonts.adamina(color: Colors.black, fontSize: 12.0.sp),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Log In", style: GoogleFonts.adamina(color: Color(0xFF2B2B81), fontSize: 14.0.sp, fontWeight: FontWeight.bold))
                            ]
                        ),
                      ),
                    ),
                  )
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 20),
                  //   child: Container(
                  //     width: double.infinity,
                  //     alignment: Alignment.bottomCenter,
                  //     child: InkWell(
                  //       onTap: (){
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => Loginpage()));
                  //       },
                  //       child: RichText(
                  //         text: TextSpan(
                  //             text: "Already have account?",
                  //             style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Raleway"),
                  //             children: <TextSpan>[
                  //               TextSpan(
                  //                   text: "Log In", style: TextStyle(color: Colors.blue, fontSize: 20, fontFamily: "gelasio")
                  //               )
                  //             ]
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future RegistrationUser() async{
    Map<String, String> JsonBody = {
      'CompanyName':_comp_name.text,
      'Address':_address.text,
      'CMobileno':_mobileno.text,
      'CEmail':_email.text,
      'CompamyPassword':_password.text,
      'Country':"",
      'State':"",
      'City':_city.text,
      'CompamyShortName':""
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "CompanyRegistration/AddCompany"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    var companyid = jsonDecode(response.body)['Response'];
    _reg = new Reg(company_name: _comp_name.text, company_id: companyid,password: _password.text,email: _email.text, Status: 1);
    if(data == 1)
    {
      var result = await DatabaseHelper.db.deleteCustomer();
      await DatabaseHelper.db.createCustomer(_reg);
      _myServices.myVideoStatus = true;
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>StartMainPage()));

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