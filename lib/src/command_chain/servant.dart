import 'package:flutter/material.dart';
import 'card.dart';

class Servant extends ChangeNotifier {
  int attack = 0;
  String name = "";
  Map<String, List<bool>> skillSelected = {};
  List<bool> npSelected = [];
  String imageUrl = "";
  dynamic servantData = "";
  dynamic data = "";
  List<ServantCard> cards = [];
  int npLevel = 1;

  void initServant(initData) {
    data = initData;
    servantData = getServant("Altria Pendragon");
    attack = servantData["atkGrowth"][0];
    name = servantData["name"];
    skillSelected = initSkillSelected(servantData);
    npSelected = initNpSelected(servantData);
    imageUrl = servantData["extraAssets"]["faces"]["ascension"]["1"]; 

    for (var card in servantData['cards']) {
      cards.add(ServantCard(card));
    }
    cards.add(ServantCard("np"));
    cards.add(ServantCard("extra"));
  }

  Map<String, List<bool>> initSkillSelected(servantData) {
    skillSelected = {"1" : [], "2" : [], "3" : []};
    String number = "";
    for (var skill in servantData["skills"]) {
      number = skill["num"].toString();
      skillSelected[number]?.add(false);
    }
    return skillSelected;
  }

  List<bool> initNpSelected(servantData) {
    npSelected = [];
    for (var _ in servantData["noblePhantasms"]) {
      npSelected.add(false);
    }
    return npSelected;
  }

  dynamic getServant(text) {
    for (var servant in data) {
      if (servant["name"] == text) {
        debugPrint(servant["name"]);
        return servant;
      }
    }
    return "";
  }

  int getActiveNp() {
    for (int i = 0; i <= npSelected.length; i++) {
      if (npSelected[i]) {
        return i;
      }
    }
    return -1;
  }

  void updateAttack(int newAttack) {
    attack = newAttack;
    notifyListeners();
  }

  void updateNpLevel(int npLevel) {
    npLevel = npLevel;
  }

  void updateSkillSelected(String skillNum, int skillButtonNum) {
    
    if (skillSelected[skillNum]![skillButtonNum]) {
      skillSelected[skillNum]![skillButtonNum] = !skillSelected[skillNum]![skillButtonNum];
    } else {
      for (int j = 0; j <= skillSelected[skillNum]!.length - 1; j++) {
        skillSelected[skillNum]![skillButtonNum] = false;
      }
      skillSelected[skillNum]![skillButtonNum] = !skillSelected[skillNum]![skillButtonNum];
    }
    notifyListeners();
  }

  void updateNpSelected(npNum) {
    if (npSelected[npNum]) {
      npSelected[npNum] = !npSelected[npNum];
    } else {
      for (int i = 0; i <= npSelected.length; i++) {
        npSelected[i] = false;
      }
      npSelected[npNum] = true;
    }
    double damageMult = servantData['noblePhantasms'][npNum]['svals'][npLevel];
    cards[5].updateNp(damageMult);
    notifyListeners();
  }

  void updateServant(newServantData, int level) {
    servantData = newServantData;
    attack = servantData["atkGrowth"][level - 1];
    name = servantData["name"];
    skillSelected = initSkillSelected(servantData);
    npSelected = initNpSelected(servantData);
    imageUrl = servantData["extraAssets"]["faces"]["ascension"]["1"];
    notifyListeners();
  }




}