import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/themes.dart';

class CollapsingListTile extends StatefulWidget{

  final String title;
  CollapsingListTile({@required this.title});

  @override
  _CollapsingListTile createState() => _CollapsingListTile();
}

class _CollapsingListTile extends State<CollapsingListTile>{

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        new RotatedBox(
            quarterTurns: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 25.0),
              child: new Text(widget.title,style: GoogleFonts.adamina(fontSize: 18.0, color: Colors.white,
              fontWeight: FontWeight.bold),),
            ),
        )
      ],
    );
  }

}