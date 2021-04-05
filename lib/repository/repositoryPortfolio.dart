import 'dart:convert';

import 'package:cashflow/models/modelPortfolio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './keys.dart';

class RepositoryPortfolio {
  SharedPreferences prefs;

  Future save(ModelPortfolio portfolio) async {
    return await SharedPreferences.getInstance()
        .then((prefs) => buildKey().then((value) {
              portfolio.key = value;
              print(json.encode(portfolio.toJson()));
              prefs.setString(portfolio.key, json.encode(portfolio));
            }));
  }

  Future<ModelPortfolio> getPortfolioFromId(int id) async {
    return await SharedPreferences.getInstance().then((prefs) {
      ModelPortfolio modelPortfolio = ModelPortfolio.fromJson(
          json.decode(prefs.get('portfolio_' + id.toString())));
      return modelPortfolio;
    });
  }

  Future<List<ModelPortfolio>> getPortfolioList() async {
    List<ModelPortfolio> result = new List<ModelPortfolio>();
    return await SharedPreferences.getInstance().then((prefs) {
      //JUST FOR RESETTING STUFF

      String _keys = prefs.get(Keys.PORTFOLIO_LOOKUPIDS);
      if (_keys == null) {
        return result;
      }
      //build key of each portfolio
      List<String> keys = _keys.split("_");
      //for each key get the portfolio
      for (String partialKey in keys) {
        String key = Keys.PORTFOLIO_ID + partialKey;
        String objectToDecode = prefs.get(key);
        if (objectToDecode == null) {
          return Future(() => result);
        }
        ModelPortfolio p = ModelPortfolio.fromJson(json.decode(objectToDecode));
        result.add(p);
      }
      return Future(() => result);
    });
  }

  Future<String> buildKey() async {
    return await SharedPreferences.getInstance().then((prefs) {
      //get last id value
      String lastId = prefs.getString(Keys.PORTFOLIO_LASTID) ?? "-1";
      //generating new id
      String newId = (int.parse(lastId) + 1).toString();
      //key for saving the next portfolio
      String usableKey = Keys.PORTFOLIO_ID + newId;
      // save the new just generated id
      prefs.setString(Keys.PORTFOLIO_LASTID, newId);
      //update the look up list
      updateListIdUsed(newId);
      return Future(() => usableKey);
    });
  }

  Future updateListIdUsed(id) async {
    return await SharedPreferences.getInstance().then((prefs) {
      //get the used ids
      String getIdsUsed = prefs.get(Keys.PORTFOLIO_LOOKUPIDS) ?? "";
      //add the new id
      String updatedList = getIdsUsed + id + "_";
      //update the list
      prefs.setString(Keys.PORTFOLIO_LOOKUPIDS, updatedList);
    });
  }

  Future deleteFromKey(key) async {
    return await SharedPreferences.getInstance().then((prefs) {
      //remove the object
      prefs.remove(key);
      //update the lookup list
      //get the lookup list
      String lookuplist = prefs.get(Keys.PORTFOLIO_LOOKUPIDS);
      //getting the last id
      String stringToReplace = (key.toString().split("_")[2]) + "_";
      //update the lookuplist
      lookuplist = lookuplist.replaceAll(stringToReplace, "");
      prefs.setString(Keys.PORTFOLIO_LOOKUPIDS, lookuplist);
    });
  }

  Future resetData() async {
    return await SharedPreferences.getInstance().then((prefs) {
      prefs.remove(Keys.PORTFOLIO_ID);
      prefs.remove(Keys.PORTFOLIO_LASTID);
      prefs.remove(Keys.PORTFOLIO_LOOKUPIDS);
    });
  }
}
