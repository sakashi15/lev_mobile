import 'dart:convert';
import 'package:lev_mobile/constants.dart';

import '../../models/salary_model.dart';
import 'package:http/http.dart' as http;

class MyHttpClient{

  static const String _baseUrl = "https://mega-tech.dev/Lev/lev-walk/api";
  static const String root = "https://mega-tech.dev/Lev/lev-walk/";

  static const String authenticated = "authenticated";
  static const String token = "token";
  static const String id = "id";
  static const String email = "email";
  static const String name = "name";

  static Future<Map<String, String>> _getHeaders(bool isAuthenticated) async {
    final Map<String, String> _defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (isAuthenticated) {
      final token = TempSalary.temp ? TempSalary.token : box.read(MyHttpClient.token);
      _defaultHeaders.addAll({"Authorization": "Bearer $token"});
    }
    return _defaultHeaders;
  }

  static Future<http.Response> get({required String path, bool isAuthenticated = false}) async {
    final _headers = await _getHeaders(isAuthenticated);
    return await http.get(
      Uri.parse(_baseUrl + path),
      headers: _headers
    );

  }

  static Future<http.Response> post({
    required String path,
    Map<String, dynamic>? data,
    bool isAuthenticated = false
  }) async {
    try {
      final _headers = await _getHeaders(isAuthenticated);
      return await http.post(
          Uri.parse(_baseUrl + path),
          headers: _headers,
          body: jsonEncode(data)
      );
    }catch(e){
      print(_baseUrl + path);
      print(e.toString());
      return null!;
    }
  }

}