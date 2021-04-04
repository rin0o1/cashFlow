import 'package:flutter/material.dart';

class TotalSection extends StatefulWidget {
  TotalSection({Key key}) : super(key: key);

  @override
  State createState() => TotalSectionState(key: this.key);
}

class TotalSectionState extends State<TotalSection> {
  TotalSectionState({Key key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
            //color: Colors.yellow,
            //borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [Colors.indigo[50], Colors.amberAccent])));
  }
}
