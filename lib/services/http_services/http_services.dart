import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpServices {

  static Future<dynamic> postMultiPartResponse(
      {required String url,
        Map<String, String>? bodyData,
        Map<String, String>? header}) async {
    final request = http.MultipartRequest("POST", Uri.parse(url));
    debugPrint("body is $bodyData");
    try {
      request.headers.addAll(header!);
      request.fields.addAll(bodyData!);

      var responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);
      // debugPrint("url is ${response.request!.url}");
      // debugPrint("status code is ${response.statusCode}");
      // debugPrint("request body ${response.body}");
      if (response.statusCode == 200) {

        return response;
      }
      return null;
    } catch (e) {
      debugPrint("multipart_method_error : $e");
      rethrow;
    }
  }

  //POST API CALL
  static Future<dynamic> postMethod(
      String url, {
        dynamic data,
        Map<String, String>? header,
      }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: header,
        body: data,
      );
      // debugPrint("url is ${response.request!.url}");
      // debugPrint("status code is ${response.statusCode}");
      // debugPrint("request body ${response.body}");
      return response;
    } catch (e) {
      debugPrint("post_method_error : $e");
      rethrow;
    }
  }
}
