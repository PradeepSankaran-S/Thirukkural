import 'dart:convert';
import 'package:flutter/services.dart';

class LocalJsonService {
  Future<dynamic> loadJson(String path) async {
    final String response = await rootBundle.loadString(path);
    final data = await json.decode(response);
    return data;
  }
}
