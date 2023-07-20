import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/CompanyRegistration.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/Reg.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/seller/start_main_page.dart';
import 'package:sizer/sizer.dart';

import '../DatabaseHelper.dart';
import '../buildInputDecoration.dart';

class Loginpage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Loginpage> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  MyServices _myServices = new MyServices();
  Reg _reg;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.indigo,
              Colors.indigoAccent,
            ]
          )
        ),
        // color: Color(0xFF2B2B81),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 7.0.w,right: 7.0.w),
            child: Container(
              height: 70.0.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg1.png"),
                    fit: BoxFit.fill
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 6.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5.0.h),
                          child: Container(
                          width: 15.w,
                          height: 15.h,
                          child: Image(image: AssetImage("assets/images/milklogo.png")),
                        ),
                        ),
                        Text("LOGIN",style: GoogleFonts.adamina(fontSize: 18.0.sp, color: Colors.blue),)
                      ],
                    ),
                  ),
                  Form(
                      key: _formkey,
                      child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(1.5.h),
                        child: Container(
                          height: 7.0.h,
                          child: TextFormField(controller: _email,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.emailAddress,
                            decoration:buildInputDecoration(FontAwesomeIcons.envelope,"Email"),
                            validator: (String value){
                              if(value.isEmpty)
                              {
                                return "Please enter Email";
                              }
                              return null;
                            },
                            onSaved: (String password){
                            },
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(1.5.h),
                        child: Container(
                          height: 7.0.h,
                          child: TextFormField(controller: _password,style: GoogleFonts.adamina(fontSize: 14.0,color: Colors.black87),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.none,
                            decoration:buildInputDecoration(FontAwesomeIcons.lockOpen,"Password"),
                            validator: (String value){
                              if(value.isEmpty)
                              {
                                return "Please enter password";
                              }
                              return null;
                            },
                            onSaved: (String password){
                            },
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 6.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: Color(0xFF2B2B81),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: (){
                                _myServices.myVideoStatus = true;
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => StartMainPage()));
                                if(_formkey.currentState.validate())
                                {
                                  EasyLoading.show(status: "Loading.....");
                                  LoginUser();
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
                              child: Text("SIGN IN",
                                  style: GoogleFonts.adamina(fontSize: 14.0.sp,color: Colors.white)),),
                          ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0),
                      child: InkWell(
                        onTap: (){

                        },
                        child: Text("Forget Password",
                          style: GoogleFonts.adamina(fontSize: 12.0.sp, color: Colors.blue),),
                      )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4.0.h),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyRegistration()));
                          },
                          child: RichText(
                            text: TextSpan(
                                text: "Create an account?",
                                style: GoogleFonts.adamina(color: Colors.black, fontSize: 12.0.sp),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Sign Up", style: GoogleFonts.adamina(color: Color(0xFF2B2B81), fontSize: 12.0.sp, fontWeight: FontWeight.bold))
                                ]
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
                ],
              ),

            ),)

          ],
        )
      ),
    );
  }

  Future LoginUser() async{
    Map<String, String> JsonBody = {
      'CEmail':_email.text,
      'CompamyPassword':_password.text
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Login/GetAdminLoginData"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    var data = jsonDecode(response.body)['Status'];
    var message = jsonDecode(response.body)['Message'];
    var companyid = jsonDecode(response.body)['Response'];
    
    if(data == 1)
    {
      EasyLoading.dismiss();
      _reg = new Reg(company_id: companyid,password: _password.text,email: _email.text, Status: 1);
      var result = await DatabaseHelper.db.deleteCustomer();
      await DatabaseHelper.db.createCustomer(_reg);
      _myServices.myVideoStatus = true;
      _myServices.myCompanyId = companyid;
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>MainPage()));
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(2)));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invaild Email and Password"),
            duration: Duration(seconds: 3),
          ));
          return;
    }

    print("DATA: ${data}");
  }
}
