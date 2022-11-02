import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_singpass/model.dart';

class DataRepo {
  static String sandBoxURL = "https://sandbox.api.myinfo.gov.sg/com/v3";
  static Future<String> sampleData({
    required String uinfin,
    required String attributes,
  }) async {
    var url = Uri.parse(
      "$sandBoxURL/person-sample/$uinfin?attributes=$attributes",
    );
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      }
      return "Error:${response.statusCode}";
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<ResponseModel> requestAuthCode({
    required String clientId,
    required String purpose,
    required String state,
    required String redirectURL,
    required String attributes,
  }) async {
    var url =
        "$sandBoxURL/authorise?attributes=$attributes&client_id=$clientId&state=$state&redirect_uri=$redirectURL&purpose=$purpose";
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin": "*",
        },
      );
      if (response.statusCode == 200) {
        return ResponseModel(
          code: 200,
          data: url,
        );
      }
      return ResponseModel(
        code: response.statusCode,
        data: response.body,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> getToken({
    required String code,
    required String state,
    required String redirectURL,
    required String clientId,
    required String clientSecret,
  }) async {
    var url = "$sandBoxURL/token";
    var headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded",
    };
    var body = {
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": redirectURL,
      "client_id": clientId,
      "client_secret": clientSecret,
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        return body["access_token"];
      }
      return "Error:${response.statusCode}";
    } catch (e) {
      return "Error:$e";
    }
  }

  static Future<String> getPersonData({
    required String sub,
    required String attributes,
    required String clientId,
    required String authorizationToken,
  }) async {
    var url =
        "$sandBoxURL/person/$sub?attributes=$attributes&client_id=$clientId";
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $authorizationToken",
        },
      );
      if (response.statusCode == 200) {
        return response.body.toString();
      }
      return "Error:${response.statusCode}";
    } catch (e) {
      return "Error:$e";
    }
  }
}
