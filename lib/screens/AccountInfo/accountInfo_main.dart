import 'dart:io';

import 'package:cashflow/models/modelPortfolio.dart';
import 'package:cashflow/repository/repositoryPortfolio.dart';
import 'package:cashflow/screens/AccountInfo/accountInfo_dataSection.dart';
import 'package:flutter/material.dart';

import 'accountInfo_addAccount.dart';

class AccountInfoMain extends StatefulWidget {
  AccountInfoMain({Key key}) : super(key: key);

  @override
  AccountInfoMainState createState() => AccountInfoMainState();
}

class AccountInfoMainState extends State<AccountInfoMain> {
  List<ModelPortfolio> portfolios = [];
  RepositoryPortfolio repPort = RepositoryPortfolio();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    await repPort.getPortfolioList().then((data) {
      setState(() {
        portfolios = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPortfolio(
                                callBackOnSave: () {
                                  this.setState(() {
                                    print("callback");
                                    isLoading = true;
                                    getData();
                                  });
                                },
                              )));
                },
              ),
            )
          ]),
          _table(context)
        ],
      ),
      Positioned(
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepOrange)),
                ),
                color: Colors.black.withOpacity(0.3),
              )
            : Container(),
      )
    ]);
  }

  //TODO: put those table into a stateless widget
  Widget _table(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 5),
                    top: BorderSide(color: Colors.greenAccent, width: 5)),
                color: Colors.green,
              ),
              margin: EdgeInsets.only(top: 5, bottom: 2),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Portfoglio",
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.wavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  ),
                  Text("Budget",
                      style: TextStyle(
                        decorationStyle: TextDecorationStyle.wavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  Text("Actual",
                      style: TextStyle(
                        decorationStyle: TextDecorationStyle.wavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text("Earn",
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.wavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  )
                ],
              ),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (portfolios.length > 0)
                  ? _buildDataSection(context)
                  : Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Text("Add a new portfolio to start"),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        //to replace that 300
        height: MediaQuery.of(context).size.height - 370,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: portfolios.length,
                  itemBuilder: (context, index) {
                    ModelPortfolio p = portfolios[index];
                    return Padding(
                        padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                        child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 50,
                            color: Colors.white,
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      top:
                                          BorderSide(color: p.color, width: 10),
                                      bottom: (p.isAnInvestment)
                                          ? BorderSide(
                                              color: Colors.orange[400],
                                              width: 5)
                                          : BorderSide(width: 0)),
                                  //color: p.color,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 7), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 7),
                                      child: Text(
                                        p.name,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Text(p.budgetInvested.toString(),
                                        style: TextStyle(fontSize: 17)),
                                    Text(
                                      p.actualBudget.toString(),
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Text(
                                          p.earnFrom.toString(),
                                          style: TextStyle(fontSize: 17),
                                        )),
                                  ],
                                ))));
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
}
