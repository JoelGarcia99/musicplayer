import 'package:flutter/services.dart';

class DatabaseHelper {

  /// Returns a transaction like string in order to
  /// be excecuted by sqflite. [route] is the path
  /// of the SQL file
  Future<List<String>> formatSQLQuery(String route) async {

    final query = (await rootBundle.loadString(route)).trim();

    List<String> response = query.split('--end');

    response = List<String>.from(response.map((element) {
      final string = element.replaceAll(r'\n', " ");
      print("query: ${string.trim()}");

      return string.trim();
    }));

    if(response.isNotEmpty) response.removeLast();

    return response;
  }
}