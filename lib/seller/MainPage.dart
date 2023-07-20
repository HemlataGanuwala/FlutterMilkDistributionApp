import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milkdistributionflutter/common/AppContainer.dart';
class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: AppBar(title: Text("Dashboard"),),
      body: Container(
        child: AppContainer(),
      ),
    );
  }

}