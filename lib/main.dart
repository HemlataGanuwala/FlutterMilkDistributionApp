import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/CompanyRegistration.dart';
import 'package:milkdistributionflutter/seller/start_main_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType){
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Dashboard'),
        builder: EasyLoading.init(),
      );
    });

  }
}

void configLoading(){
  EasyLoading.instance
  ..displayDuration = const Duration(milliseconds: 2000)
  ..indicatorType = EasyLoadingIndicatorType.fadingCircle
  ..loadingStyle = EasyLoadingStyle.dark
  ..indicatorSize = 45.0
  ..radius = 10.0
  ..progressColor = Colors.yellow
  ..backgroundColor = Colors.green
  ..indicatorColor = Colors.yellow
  ..textColor = Colors.yellow
  ..maskColor = Colors.blue.withOpacity(0.5)
  ..userInteractions = true
  ..dismissOnTap = false;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                StartMainPage()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10.0),
            child: Image(image: AssetImage('assets/images/milklogo.png')),),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text("Milk Distribution Billing App",style: GoogleFonts.adamina(fontSize: 24.0, color: Colors.blue,
                  decoration: TextDecoration.none),
                textAlign: TextAlign.center,),
            ),

          ],
        )
    );
  }
}

// class SecondScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.only(top: 20.0),
//               child: Text("Registration", style: GoogleFonts.adamina(color: Colors.black,fontSize: 18.0,decoration: TextDecoration.none),
//               textAlign: TextAlign.center,),
//             ),
//             Container(
//               child: Column(
//                 child: Form(
//                   key: _formkey,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 70),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 20),
//                               child: Container(
//                                 height: 150,
//                                 width: 150,
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: AssetImage("asset/image/restralogo.png"),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
//                               child: TextFormField(
//                                 controller: _name,
//                                 style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "gelasio"),
//                                 textInputAction: TextInputAction.next,
//                                 textCapitalization: TextCapitalization.words,
//                                 keyboardType: TextInputType.name,
//                                 decoration:buildInputDecoration(FontAwesomeIcons.user,"Name"),
//                                 validator: (String value){
//                                   if(value.isEmpty)
//                                   {
//                                     return "Please enter name";
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (String name){
//                                 },
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
//                               child: TextFormField(
//                                 controller: _email,
//                                 style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "gelasio"),
//                                 textInputAction: TextInputAction.next,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration:buildInputDecoration(FontAwesomeIcons.envelope,"Email"),
//                                 validator: (String value){
//                                   if(value.isEmpty)
//                                   {
//                                     return "Please enter email";
//                                   }
//                                   if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
//                                     return 'Please a valid Email';
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (String email){
//                                 },
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
//                               child: TextFormField(
//                                 controller: _password,
//                                 style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "gelasio"),
//                                 textInputAction: TextInputAction.next,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration:buildInputDecoration(FontAwesomeIcons.lock,"Password"),
//                                 validator: (String value){
//                                   if(value.isEmpty)
//                                   {
//                                     return "Please enter password";
//                                   }
//                                   return null;
//                                 },
//                                 onSaved: (String password){
//                                 },
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Container(
//                                   height: 50,
//                                   width: 200,
//                                   decoration: BoxDecoration(
//                                     color: Colors.black87.withOpacity(0.5),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: Column(
//                                     children: <Widget>[
//                                       RaisedButton(
//                                         onPressed: (){
//                                           if(_formkey.currentState.validate())
//                                           {
//                                             RegistrationUser();
//                                             print("Successful");
//                                           }else
//                                           {
//                                             print("Unsuccessfull");
//                                           }
//                                         },
//                                         textColor: Colors.white,
//                                         color: Colors.transparent,
//                                         child: Text("REGISTER",
//                                           style: TextStyle(
//                                               fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "gelasio"
//                                           ),),),
//                                     ],
//                                   )
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Spacer(),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 20),
//                         child: Container(
//                           width: double.infinity,
//                           alignment: Alignment.bottomCenter,
//                           child: InkWell(
//                             onTap: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => Loginpage()));
//                             },
//                             child: RichText(
//                               text: TextSpan(
//                                   text: "Already have account?",
//                                   style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Raleway"),
//                                   children: <TextSpan>[
//                                     TextSpan(
//                                         text: "Log In", style: TextStyle(color: Colors.blue, fontSize: 20, fontFamily: "gelasio")
//                                     )
//                                   ]
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       )
//     );
//   }
// }

