import 'dart:convert';

import 'package:flutter/services.dart';

class Players {
  String keyword;
  int id;
  String autocompleteterm;
  String country;
  var value;
  Players({
    this.keyword,
    this.id,
    this.autocompleteterm,
    this.country,
    this.value
  });

  factory Players.fromJson(Map<String, dynamic> parsedJson) {
    return Players(
        keyword: parsedJson['title']["rendered"] as String,
        id: parsedJson['id'],
        autocompleteterm: parsedJson['title']["rendered"] as String,
        country: parsedJson['date'] as String,
        value: parsedJson,
    );
  }
}

class PlayersViewModel {
  static List<Players> players;

  static Future loadPlayers(var parsedJson) async {
    try {
      players = new List<Players>();
      // String jsonString = await rootBundle.loadString('assets/players.json');
      // Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson as List;
      for (int i = 0; i < categoryJson.length; i++) {
        players.add(new Players.fromJson(categoryJson[i]));
      }
    } catch (e) {
      print(e);
    }
  }
}