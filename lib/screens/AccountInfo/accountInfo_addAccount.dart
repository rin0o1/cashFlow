import 'dart:io';
import 'package:cashflow/shared/sharedDialog.dart';
import 'package:flutter/material.dart'
    hide
        DropdownButton,
        DropdownButtonFormField,
        DropdownButtonHideUnderline,
        DropdownMenuItem;
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  State createState() => ProfileScreenState(key: this.key);
}

class ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenState({Key key});

  TextEditingController investedBudgetController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final portfolio = Portfolio();

  Color pickerColor;
  Color currentColor;

  @override
  void initState() {
    super.initState();
    pickerColor = portfolio.color;
    currentColor = portfolio.color;
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                color: Colors.green,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Text(
            "Create new portfolio",
          ),
          centerTitle: true,
          elevation: 5.0,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: formBuilder(),
        )));
  }

  Widget formBuilder() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      child: Builder(
        builder: (context) => Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            //NAME
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'How do you whish call the new portfolio?'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid name';
                }
              },
              onSaved: (val) => setState(() => portfolio.name = val),
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: FlatButton(
                  color: pickerColor,
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Container(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 2),
                                    child: Icon(
                                      Icons.color_lens_rounded,
                                      color: pickerColor,
                                    ),
                                  ),
                                  Text("PICK A COLOR",
                                      style: TextStyle(
                                        decorationStyle:
                                            TextDecorationStyle.wavy,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: pickerColor,
                                      )),
                                ],
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ),
                            actions: <Widget>[
                              Column(children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FlatButton(
                                      color: Colors.green[800],
                                      onPressed: () {
                                        currentColor = pickerColor;
                                        portfolio.color = pickerColor;
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('SAVE'),
                                    ),
                                  ],
                                ),
                              ])
                            ],
                          );
                        });
                  },
                  child: Text('PICK A COLOR'),
                )),
            //ACTUAL BUDGET
            Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: 'Actual budget',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Icon(Icons.monetization_on,
                          color: Colors.orange[400]),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                  },
                  onSaved: (val) => setState(
                      () => portfolio.actualBudget = double.parse(val)),
                  onChanged: (val) {
                    portfolio.actualBudget = double.parse(val);
                    if (!portfolio.isAnInvestment) {
                      return;
                    }
                    setState(() {
                      if (portfolio.initialBudget > 0) portfolio.getEarn();
                    });
                  },
                )),
            //IS AN INVESTMENT
            SwitchListTile(
              contentPadding: EdgeInsets.only(top: 20),
              title: Container(
                  width: 100,
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10, left: 16),
                      child: Icon(
                        Icons.trending_up_sharp,
                        color: Colors.green[800],
                      ),
                    ),
                    Text("Investment")
                  ])),
              value: portfolio.isAnInvestment,
              onChanged: (bool val) {
                setState(() {
                  portfolio.isAnInvestment = val;
                  portfolio.initialBudget = 0;
                  if (!val) {
                    investedBudgetController.text = "";
                  }
                  portfolio.earnFrom = 0;
                });
              },
            ),
            //BUDGET INVESTED
            Container(
              child: TextFormField(
                controller: investedBudgetController,
                enabled: portfolio.isAnInvestment,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Budget invested',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.monetization_on_outlined,
                      color: (portfolio.isAnInvestment)
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ),
                ),
                validator: (!portfolio.isAnInvestment)
                    ? null
                    : (value) {
                        if (value.isEmpty || double.parse(value) == 0) {
                          return 'Please enter a valid number';
                        }
                      },
                onSaved: (!portfolio.isAnInvestment)
                    ? null
                    : (val) => setState(
                        () => portfolio.initialBudget = double.parse(val)),
                onChanged: (val) {
                  setState(() {
                    print("Budget investedString: " + val);
                    if (val.isEmpty) {
                      portfolio.initialBudget = 0;
                      portfolio.earnFrom = 0;
                      return;
                    }
                    portfolio.initialBudget = double.parse(val);
                    if (portfolio.initialBudget > 0) portfolio.getEarn();
                  });
                },
              ),
            ),

            (portfolio.isAnInvestment)
                ? Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Icon(
                            Icons.business_center,
                            color: (portfolio.earnFrom >= 0)
                                ? Colors.green[600]
                                : Colors.red[700],
                          ),
                        ),
                        Text("Earn: " + (portfolio.earnFrom).toString(),
                            style: TextStyle(
                              decorationStyle: TextDecorationStyle.wavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: (portfolio.earnFrom >= 0)
                                  ? Colors.green[600]
                                  : Colors.red[700],
                            )),
                      ],
                    ),
                  )
                : Container(),

            //BUTTONS FOR SUBMITTING THE FORM
            Container(
                margin: EdgeInsets.only(top: 230),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      color: Colors.amber[900],
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('CANC'),
                    ),
                    FlatButton(
                      color: Colors.green[800],
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          portfolio.save();
                          _showDialog(context);
                        }
                      },
                      child: Text('SAVE'),
                    ),
                  ],
                )),
          ]),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    Fluttertoast.showToast(msg: "Error");
    Dialogs.confermationDialog(
        context, "SAVE", "Are you sure you want to save??", () {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Element Saved')));
//      Navigator.pop(context, true);
    });
  }
}

class Portfolio {
  int id;
  String name = '';
  bool isAnInvestment = false;
  double initialBudget = 0;
  double actualBudget = 0;
  double earnFrom = 0;
  Color color = Colors.blue[200];

  save() {
    print(this.toString());
  }

  getEarn() {
    print("Actual budget " + actualBudget.toString());
    print("Initial budget " + initialBudget.toString());
    earnFrom = actualBudget - initialBudget;
    return earnFrom;
  }
}
