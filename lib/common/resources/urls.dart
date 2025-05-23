
import '../../imports/app_configuration.dart';

class UrlPrefixes {
  static  String baseUrl = AppEnvironments.baseUrl;
  static  String baseWebUrl = AppEnvironments.baseWebUrl;
}

class UrlSuffixes{
  //Example
  static const String trainingApi = "training/create_training/";
  static const String contactUs = 'contact-us/submit/';

  static const String verifyReceiptSandbox = 'https://sandbox.itunes.apple.com/verifyReceipt';
  static const String verifyReceiptProduction = 'https://buy.itunes.apple.com/verifyReceipt';
  static const String verifyPurchase = '/verify-purchase';
}