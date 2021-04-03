import 'package:flutter/material.dart';

import 'accountInfo_addAccount.dart';

class AccountInfoMain extends StatefulWidget {
  AccountInfoMain({Key key}) : super(key: key);

  @override
  AccountInfoMainState createState() => AccountInfoMainState();
}

class AccountInfoMainState extends State<AccountInfoMain> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTotalSections(context),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
              child: FlatButton(
                height: 50,
                color: Colors.yellow,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
            )
          ]),
          Row(children: [
            Container(
              color: Colors.green,
              margin: EdgeInsets.only(top: 5),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Portfoglio"),
                  Text("Budget"),
                  Text("Actual"),
                  Text("Diff"),
                  Text("Col")
                ],
              ),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDataSection(context),
            ],
          )
        ],
      ),
    );
  }
}

Widget buildDataSection(BuildContext context) {
  var width = MediaQuery.of(context).size.width;

  return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: MediaQuery.of(context).size.width,
      //to replace that 300
      height: MediaQuery.of(context).size.height - 370,
      color: Colors.amberAccent,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 18,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                      child: Container(
                          height: 40,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Portfoglio"),
                              Text("Budget"),
                              Text("Actual"),
                              Text("Diff"),
                              Text("Col")
                            ],
                          )));
                })
          ])));
}

Widget buildTotalSections(BuildContext context) {
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
