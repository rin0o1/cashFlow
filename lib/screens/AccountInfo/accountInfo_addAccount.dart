import 'dart:io';
import 'package:cashflow/models/modelPortfolio.dart';
import 'package:cashflow/repository/repositoryPortfolio.dart';
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

class AddPortfolio extends StatefulWidget {
  final VoidCallback callBackOnSave;

  AddPortfolio({Key key, this.callBackOnSave}) : super(key: key);

  @override
  State createState() =>
      AddPortfolioState(key: this.key, callBackOnSave: this.callBackOnSave);
}

class AddPortfolioState extends State<AddPortfolio> {
  AddPortfolioState({Key key, this.callBackOnSave});

  TextEditingController investedBudgetController = TextEditingController();
  VoidCallback callBackOnSave;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final portfolio = ModelPortfolio(
      name: "",
      isAnInvestment: false,
      budgetInvested: 0,
      actualBudget: 0,
      earnFrom: 0,
      color: Colors.blue[200]);

  Color pickerColor;
  Color currentColor;

  RepositoryPortfolio repoPortfolio = RepositoryPortfolio();

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
                if (value.isEmpty || value == null) {
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
                                  currentColor = pickerColor;
                                  portfolio.color = pickerColor;
                                  Navigator.of(context).pop();
                                },
                                child: Text('SAVE'),
                              ),
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
                      if (portfolio.budgetInvested > 0) portfolio.getEarn();
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
                  portfolio.budgetInvested = 0;
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
                        () => portfolio.budgetInvested = double.parse(val)),
                onChanged: (val) {
                  setState(() {
                    print("Budget investedString: " + val);
                    if (val.isEmpty) {
                      portfolio.budgetInvested = 0;
                      portfolio.earnFrom = 0;
                      return;
                    }
                    portfolio.budgetInvested = double.parse(val);
                    if (portfolio.budgetInvested > 0) portfolio.getEarn();
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
                        //SUBMIT AND SAVE
                        if (form.validate()) {
                          form.save();
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
    Dialogs.confermationDialog(
        context, "SAVE", "Are you sure you want to save??", () {
      repoPortfolio.save(portfolio).then((value) {
        Fluttertoast.showToast(
            msg: "Element saved",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.pop(context, true);
        callBackOnSave();
      });
    });
  }
}
