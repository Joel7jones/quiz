import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;
  // final BaseOptions _baseOptions = API.networkConfig!.baseOptions;

  Future<dynamic> get(String url, {headers}) async {
    http.Response? response;
    try {
      response = await http.get(Uri.parse(url), headers: headers);
    } on Error catch (e) {
      debugPrint(e.toString());
      return null;
    }
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }
}
