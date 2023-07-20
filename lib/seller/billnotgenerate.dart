import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillNotGenerate extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(       
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                 height: MediaQuery.of(context).size.height/2,
                child: Image.asset('assets/images/billgenerate.png', 
                fit: BoxFit.fitWidth,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Bill not generated for this month',
                style: GoogleFonts.aclonica(fontSize: 20.0,
                color: Colors.red[800]),),
              )
            ],
          ),
    );
  }

}