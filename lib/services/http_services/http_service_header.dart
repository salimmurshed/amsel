import 'dart:convert';


// set header for http
String deviceName = "",
    deviceOsVersion = "",
    deviceOs = "",
    deviceLanguage = "en",
    deviceRegion = "";

Future<Map<String, String>> setHeader() async {
  Map<String, String>? headers;

  String username = "mueller";
  String password = "derbomberdernation";
  String credentials = "$username:$password";
  String auth = "Basic ${base64Encode(utf8.encode(credentials))}";

  headers = {
    KeyManager.device_language : deviceLanguage,
    KeyManager.content_type: KeyManager.multipart_data,
    KeyManager.authorization: auth
  };


  return headers;
}

class KeyManager {
  static const String content_type = "content-Type";
  static const String application_json = "application/json";
  static const String multipart_data = "multipart/form-data";
  static const String url_encoded = "application/x-www-form-urlencoded";
  static const String authorization = "Authorization";
  static const String bearer = "token";
  static const String device_name_header = "x-device-name";
  static const String device_os_version_header = "x-os-version";
  static const String device_os_header = "x-os";
  static const String device_language = "default_language";
  static const String device_region_header = "x-device-region";

}
