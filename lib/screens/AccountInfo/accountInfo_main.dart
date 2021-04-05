import 'dart:io';

import 'package:cashflow/models/modelPortfolio.dart';
import 'package:cashflow/repository/repositoryPortfolio.dart';
import 'package:cashflow/screens/AccountInfo/accountInfo_dataSection.dart';
import 'package:cashflow/shared/sharedDialog.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
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

  double total = 0;
  double usable = 0;
  double totalInvested = 0;
  double actualInvested = 0;
  double totalEarn = 0;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    await repPort.getPortfolioList().then((data) {
      setState(() {
        portfolios = data;
        //calculatin totals variables
        for (ModelPortfolio p in portfolios) {
          total += p.actualBudget;
          if (p.isAnInvestment) {
            totalInvested += p.budgetInvested;
            actualInvested += p.actualBudget;
            totalEarn += p.earnFrom;
          }
        }
        usable = total - totalInvested;
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
              padding: EdgeInsets.only(top: 10, left: 5),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 80,
                    child: Text("Portfoglio",
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.wavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                  Container(
                    height: 40,
                    width: 80,
                    child: Text("Budget",
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.wavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                  Container(
                    height: 40,
                    width: 80,
                    child: Text("Actual",
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.wavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                  Container(
                    height: 40,
                    width: 80,
                    child: Text("Earn",
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.wavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                  Container(
                    height: 40,
                    width: 25,
                    child: Text("  ",
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.wavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
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
                        child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              tapBodyToExpand: true,
                              tapBodyToCollapse: true,
                              hasIcon: false,
                            ),
                            expanded: Container(
                              height: 20,
                              margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FlatButton(
                                    color: Colors.red[600],
                                    onPressed: () => {_deleteElement(p.key)},
                                    child: Container(
                                        width: 80,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                            Text("DELETE",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  decorationStyle:
                                                      TextDecorationStyle.wavy,
                                                  fontSize: 14,
                                                )),
                                          ],
                                        )),
                                  ),
                                  FlatButton(
                                    color: Colors.yellow[700],
                                    onPressed: () {},
                                    child: Container(
                                        width: 80,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: Icon(
                                                Icons.info,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                            Text("INFO",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  decorationStyle:
                                                      TextDecorationStyle.wavy,
                                                  fontSize: 14,
                                                )),
                                          ],
                                        )),
                                  ),
                                  FlatButton(
                                    color: Colors.orange,
                                    onPressed: () {},
                                    child: Container(
                                        width: 80,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                            Text("EDIT",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  decorationStyle:
                                                      TextDecorationStyle.wavy,
                                                  fontSize: 14,
                                                )),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            collapsed: Container(),
                            header: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                height: 50,
                                color: Colors.white,
                                child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: p.color, width: 10),
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
                                          offset: Offset(0,
                                              7), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 80,
                                          child: Text(p.name,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: p.color)),
                                        ),
                                        Container(
                                          width: 80,
                                          child: Text(
                                            p.budgetInvested.toString(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          child: Text(
                                            p.actualBudget.toString(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        (p.isAnInvestment)
                                            ? Container(
                                                color: (p.earnFrom >= 0)
                                                    ? Colors.green[200]
                                                    : Colors.red[200],
                                                width: 80,
                                                child: Text(
                                                    p.earnFrom.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (p.earnFrom >= 0)
                                                            ? Colors.green[800]
                                                            : Colors.red[800])),
                                              )
                                            : Container(
                                                width: 80,
                                                child: Text("NO EARN"),
                                                color: Colors.grey[400],
                                              ),
                                        ExpandableIcon(
                                          theme: const ExpandableThemeData(
                                            expandIcon:
                                                Icons.arrow_back_ios_outlined,
                                            iconColor: Colors.black,
                                            iconSize: 24.0,
                                            iconRotationAngle: -3.141592654 / 2,
                                            iconPadding:
                                                EdgeInsets.only(right: 1),
                                            hasIcon: false,
                                          ),
                                        ),
                                      ],
                                    )))));
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
              colors: [Colors.indigo[50], Colors.amberAccent])),
      child: Column(
        children: [
          Row(
            children: [Text("TOTAL " + total.toString() ?? "")],
          ),
          Row(
            children: [Text("USABLE " + usable.toString() ?? "")],
          ),
          Row(
            children: [
              Text("TOTAL INVESTED " + totalInvested.toString() ?? "")
            ],
          ),
          Row(
            children: [
              Text("ACTUAL INVESTED " + actualInvested.toString() ?? "")
            ],
          ),
          Row(
            children: [Text("TOTAL EARN " + totalEarn.toString()) ?? ""],
          )
        ],
      ),
    );
  }

  _deleteElement(key) {
    Dialogs.confermationDialog(
        context, "DELETE", "Are you sure you want to delete this element??",
        () {
      setState(() {
        repPort.deleteFromKey(key).then((x) {
          isLoading = true;
          getData();
        });
      });
    });
  }
}
