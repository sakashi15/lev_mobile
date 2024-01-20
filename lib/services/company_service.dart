import 'dart:convert';
import 'package:lev_mobile/models/company_model.dart';
import 'package:lev_mobile/network/my_http_client.dart';
import 'package:lev_mobile/network/urls.dart';

class CompanyService {
  static Future<List<Company>> getAllCompanies() async {
    final response = await MyHttpClient.get(
      path: URLs.allCompanies,
    );
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List.generate(
        (result["data"] as List).length,
            (index) => Company.dataFromJson((result["data"] as List)[index]),
      );
    } else {
      return [];
    }
  }
}