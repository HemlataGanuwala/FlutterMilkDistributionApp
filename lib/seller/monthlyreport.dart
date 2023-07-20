import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:milkdistributionflutter/common/AppContainer.dart';
import 'package:milkdistributionflutter/model/MonthlyReportModel.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkdistributionflutter/seller/monthlycustlist.dart';

class MonthlyReport extends StatefulWidget {
  int custid;
  String custname;

  MonthlyReport(this.custid,this.custname);

  @override
  State<StatefulWidget> createState() {
    return MonthlyReportState(custid,custname);
  }
}

class MonthlyReportState extends State<MonthlyReport> {
  int custid;
  String custname;
  MonthlyReportState(this.custid,this.custname);

  String dropdownValue;
  String dropdownYear;
  List<MonthlyReportModel> monthlylist;
  Future<List<MonthlyReportModel>> monthlyfuture;
  MyServices _myServices = MyServices();
  int cyear;
  String addYears = "", currmonth = "";
  List<String> spinnerItems = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  DateTime currdt = DateTime.now();
  List<String> spinnerYears;
TextEditingController _name = TextEditingController();  

  @override
  void initState() {
    super.initState();
    cyear = (currdt.year - 1);
    currmonth = (currdt.month).toString();
    var prevMonth = new DateTime(currdt.year, currdt.month, currdt.day);
    dropdownValue = DateFormat("MMMM").format(prevMonth).toString();
     
    dropdownYear = (currdt.year).toString();
    for (int i = 0; i < 5; i++) {
      addYears = (cyear).toString();
      spinnerYears.add(addYears);
      cyear++;
    }
    monthlyfuture = getMonthlyData(); 
    // dropdownYear = (cyear).toString();
  }

  Future<List<MonthlyReportModel>> getMonthlyData() async{
    Map<String, String> JsonBody = {
      'Id':  custid.toString(),
      'CompanyId':  _myServices.myCompanyId,
      'Cmonth':  currmonth,
      'Cyear':  dropdownYear,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Reports/GetMonthMilkReport"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['Response'];
      var message = jsonDecode(response.body)['Message'];
      if(message == "Customer not register in this month"){
       
      }
      else{
         monthlylist= List< MonthlyReportModel >.from((json.decode(response.body)['Response']).map((i) => MonthlyReportModel.fromJson(i)));
        return monthlylist;
      }
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xFF2B2B81),
                    Colors.white54,
                  ])),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 30.0, left: 10.0),
                      alignment: Alignment.topLeft,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MonthlyCustomerList()));
                          },
                          child: Image.asset(
                            'assets/images/back_icon.png',
                            width: 30.0,
                            height: 30.0,
                          ))),
                  Image.asset(
                    'assets/images/milklogo.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  Text(
                    'Monthly Report',
                    style: GoogleFonts.aclonica(
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  //DropDown Month and Year
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0, bottom: 20.0),
                        height: 30.0,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.5,
                                color: Colors.white,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            underline: Container(),
                            onChanged: (String data) {
                              setState(() {
                                if(data == "January")
                                {
                                  currmonth = "1";
                                }
                                else if(data == "February")
                                {
                                  currmonth = "2";
                                }
                                else if(data == "March")
                                {
                                  currmonth = "3";
                                }
                                else if(data == "April")
                                {
                                  currmonth = "4";
                                }
                                else if(data == "May")
                                {
                                  currmonth = "5";
                                }
                                else if(data == "June")
                                {
                                  currmonth = "6";
                                }
                                else if(data == "July")
                                {
                                  currmonth = "7";
                                }
                                else if(data == "August")
                                {
                                  currmonth = "8";
                                }
                                else if(data == "September")
                                {
                                  currmonth = "9";
                                }
                                else if(data == "October")
                                {
                                  currmonth = "10";
                                }
                                else if(data == "November")
                                {
                                  currmonth = "11";
                                }
                                else if(data == "December")
                                {
                                  currmonth = "12";
                                }
                                dropdownValue = data;                                
                              });
                               setState(() {
                                monthlyfuture = getMonthlyData();
                              });
                            },
                            items: spinnerItems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 20.0),
                        height: 30.0,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.5,
                                color: Colors.white,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: DropdownButton<String>(
                            value: dropdownYear,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            underline: Container(),
                            onChanged: (String data) {
                              setState(() {
                                dropdownYear = data;                                
                              });
                              setState(() {
                                monthlyfuture = getMonthlyData();
                              });
                            },
                            items: spinnerYears
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //List and Name
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text('Ritika Ganuwala', style: GoogleFonts.aclonica(fontSize: 20.0,
                    color: Colors.black),),
                  ),
                  Container(                    
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[400]),
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(   
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,                                      
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width/5,
                          child: Text('Date')
                          ),
                          VerticalDivider(color: Colors.black,),
                        Container(
                          width: MediaQuery.of(context).size.width/5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Buffalo'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Half'),
                                  VerticalDivider(color: Colors.black,),
                                  Text('Full'),
                                ],
                              )
                            ],
                          ),
                        ),
                        VerticalDivider(color: Colors.black,),
                        Container(
                          width: MediaQuery.of(context).size.width/5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Cow'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Half'),
                                  VerticalDivider(thickness: 3,color: Colors.black,),
                                  Text('Full'),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                  ),
                ],
              ),
            ),
            Container(
              child: FutureBuilder<List<MonthlyReportModel>>(
                future: monthlyfuture,
                builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: CircularProgressIndicator());
                  if(snapshot.hasData){
                    if(monthlylist.length != 0){
                      List<MonthlyReportModel> cartitem = snapshot.data;
                    } 
                  }                 
                  return Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int contextIndex){
                          return Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Text(snapshot.data[contextIndex].CustDate),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(snapshot.data[contextIndex].Buff_half.toString()),
                                      Text(snapshot.data[contextIndex].Buff_full.toString()),
                                    ],
                                  )
                                ),                              
                                Container(
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(snapshot.data[contextIndex].Cow_half.toString()),
                                      Text(snapshot.data[contextIndex].Cow_full.toString()),
                                    ],
                                  )
                                ),                             
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  );
              },)
            ),
          ],
        ),
      ),
    );
  }
}
