import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/model/MinkmanModel.dart';
import 'package:sizer/sizer.dart';

import '../MyServices.dart';
import 'package:http/http.dart' as http;

import '../model/MinkmanListModel.dart';
import 'edit_milkman.dart';

class MilkmanList extends StatefulWidget{
  @override
  MilkmanListState createState() => MilkmanListState();

}

class MilkmanListState extends State<MilkmanList>{
  MyServices _myServices = MyServices();
  Future<List<MilkmanListModel>> milkmanfuture;
  List< MilkmanListModel > milkmanList = [];
  List< MilkmanListModel > searchList;

  @override
  void initState() {    
    super.initState();
    milkmanList = [];
    milkmanfuture = getMilkmanData();
    milkmanfuture.then((value){
      setState(() {
        if(milkmanList.length == 0){
          searchList = milkmanList;
        }
        else{
          searchList = milkmanList;
        }
        // searchList = milkmanList;
      });
    });
    
  }

  Future<List<MilkmanListModel>> getMilkmanData() async{
    Map<String, String> JsonBody = {
      'CompanyId':  _myServices.myCompanyId,
    };
    var response = await http.post(Uri.parse(_myServices.myUrl + "Agent/GetAgent"),
        body: JsonBody,
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      milkmanList= List< MilkmanListModel >.from((json.decode(response.body)['Response']).map((i) => MilkmanListModel.fromJson(i)));
      return milkmanList;
    }
    else {
      // throw Exception('Failed to load data from Server.');
    }
  }

  void _runFilter(String enteredKeyword) {
    List<MilkmanListModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = milkmanList;
    } else {
      results = milkmanList
          .where((user) =>
          user.AgentName.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Milkman List")),
        backgroundColor: Color(0xFF2B2B81),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height/16,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: TextField(style: GoogleFonts.adamina(fontSize: 14.0.sp, color: Colors.black87),
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  prefixIcon: Visibility(
                    child: Icon(Icons.search, color: Colors.grey,),
                  ),
                ),),
            ),
            Container(
              child: FutureBuilder<List<MilkmanListModel>>(
                future: milkmanfuture,
                builder: (context,snapshot){
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: CircularProgressIndicator());
                  if(snapshot.hasData){
                    List<MilkmanListModel> cartitem = snapshot.data;
                  }
                  return Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: searchList.length,
                      itemBuilder: (BuildContext context, int contextIndex){
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditMilkman(searchList[contextIndex].Pin.toString())))
                              .then((value) => setState(() {
                                milkmanfuture = getMilkmanData();
                                            milkmanfuture.then((value){
                                              setState(() {
                                                searchList = milkmanList;
                                              });
                                            });}));
                            //Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => EditMilkman(searchList[contextIndex].Pin.toString()))).then((value) => setState(() {}));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 10.0,right: 10.0),
                                width: double.infinity,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.person, color: Colors.red, size: 20.sp,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(searchList[contextIndex].AgentName,
                                        style: GoogleFonts.adamina(fontSize: 12.0.sp, color: Color(0xFF2B2B81), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 5.0),
                                width: double.infinity,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.phone, color: Colors.green, size: 20.sp,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(searchList[contextIndex].MobileNo,
                                        style: GoogleFonts.adamina(fontSize: 12.0.sp, color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: Text(searchList[contextIndex].AgentStatus,
                                        style: GoogleFonts.adamina(fontSize: 12.0.sp, color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 5.0),
                                width: double.infinity,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.pin, color: Colors.indigo, size: 20.sp,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(searchList[contextIndex].Pin,
                                        style: GoogleFonts.adamina(fontSize: 12.0.sp, color: Colors.brown,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
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
                },
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}

