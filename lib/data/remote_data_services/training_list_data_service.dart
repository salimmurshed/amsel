
import 'package:amsel_flutter/common/functions/other.dart';
import 'package:flutter/cupertino.dart';
import '../../common/resources/urls.dart';
import '../../services/http_services/http_service_header.dart';
import '../../services/http_services/http_services.dart';
import '../model/api_request_models/contact_us_request_model.dart';
import '../model/api_request_models/training_request_model.dart';

class TrainingListDataService {
  static Future trainingList(
      {required TrainingRequestModel trainingRequestModel}) async {
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.trainingApi}';

    Map<String, String> bodyData = {
      "app_version": "4.1.1",
      "api_version": "2",
      "duration": trainingRequestModel.duration.round().toString(),
      "level": trainingRequestModel.level,
      "type": trainingRequestModel.type,
      "country": getLocale() == const Locale("de")? "de" : "en",
      if (trainingRequestModel.voice.isNotEmpty)
        "voice": trainingRequestModel.voice,
    };

    List<String> focusList = trainingRequestModel.focus.split(",");
    // debugPrint("is list empty ${focusList.isNotEmpty} length ${focusList.length} list is ${trainingRequestModel.focus}");
    if (trainingRequestModel.focus.isNotEmpty)
      for (String s in focusList) {
        bodyData[s] = '5';
      }

    final response = await HttpServices.postMultiPartResponse(
        url: baseUrl, bodyData: bodyData, header: await setHeader());
    return response;
  }

  static Future contactUs(
      {required ContactUsRequestModel contactUsRequestModel}) async {
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.contactUs}';
    Map<String, String> data = {
      "first_name": contactUsRequestModel.firstName,
      "last_name": contactUsRequestModel.lastName,
      "email": contactUsRequestModel.email,
      "news": contactUsRequestModel.news,
      if(contactUsRequestModel.company != null)
        "company": contactUsRequestModel.company!,
    };
    final response = await HttpServices.postMultiPartResponse(url: baseUrl,
        bodyData: data, header: await setHeader());
    return response;
  }
}
