import 'package:cashflow/screens/AccountInfo/accountInfo_main.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cashflow",
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Cashflow'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.table_chart),
                ),
                Tab(
                  icon: Icon(Icons.pie_chart),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[AccountInfoMain(), Container()],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
