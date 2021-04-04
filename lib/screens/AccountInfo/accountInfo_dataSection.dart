import 'package:cashflow/models/modelPortfolio.dart';
import 'package:flutter/material.dart';

class DataSection extends StatefulWidget {
  final List<ModelPortfolio> portfolio;

  DataSection({this.portfolio});

  @override
  State<StatefulWidget> createState() =>
      _DataSection(portfolio: this.portfolio);
}

class _DataSection extends State<DataSection> {
  List<ModelPortfolio> portfolio = [];
  _DataSection({this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
              (portfolio.length > 0)
                  ? buildDataSection(context)
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

  Widget buildDataSection(BuildContext context) {
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: portfolio.length,
                  itemBuilder: (context, index) {
                    ModelPortfolio p = portfolio[index];
                    return Padding(
                        padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                        child: Container(
                            height: 40,
                            color: Colors.white,
                            child: Container(
                                color: p.color,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(p.name),
                                    Text(p.budgetInvested.toString()),
                                    Text(p.actualBudget.toString()),
                                    Text(p.earnFrom.toString()),
                                  ],
                                ))));
                  })
            ])));
  }
}
