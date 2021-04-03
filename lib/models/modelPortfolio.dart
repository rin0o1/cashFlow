import 'dart:convert';

import 'package:flutter/material.dart';

class ModelPortfolio {
  ModelPortfolio(
      {this.key,
      this.date,
      this.name,
      this.isAnInvestment,
      this.budgetInvested,
      this.actualBudget,
      this.earnFrom,
      this.color});

  String key;
  DateTime date;
  String name = '';
  bool isAnInvestment = false;
  double budgetInvested = 0;
  double actualBudget = 0;
  double earnFrom = 0;
  Color color = Colors.blue[200];

  getEarn() {
    print("Actual budget " + actualBudget.toString());
    print("Initial budget " + budgetInvested.toString());
    earnFrom = actualBudget - budgetInvested;
    return earnFrom;
  }

  factory ModelPortfolio.fromJson(Map<String, dynamic> jsonMap) {
    return ModelPortfolio(
      key: jsonMap["key"],
      date: jsonMap["date"],
      name: jsonMap["name"],
      isAnInvestment: jsonMap["isAnInvestment"],
      budgetInvested: jsonMap["budgetInvested"],
      actualBudget: jsonMap["actualBudget"],
      earnFrom: jsonMap["earnFrom"],
      color: jsonMap["color"],
    );
  }

  Map<String, dynamic> toJson() => {
        "key": key,
        "date": DateTime.now().toString(),
        "name": name,
        "isAnInvestment": isAnInvestment,
        "budgetInvested": budgetInvested,
        "actualBudget": actualBudget,
        "earnFrom": earnFrom,
        "color": color.value.toString()
      };
}
