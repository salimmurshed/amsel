import 'dart:convert';
import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../common/functions/exception_handler.dart';
import '../model/api_request_models/contact_us_request_model.dart';
import '../model/api_request_models/training_request_model.dart';
import '../model/api_response_models/common_response_model.dart';
import '../model/api_response_models/interval_data.dart';
import '../model/api_response_models/training_response.dart';
import '../remote_data_services/training_list_data_service.dart';

class TrainingRepository {
  static Future<Either<Failure, TrainingResponse>> trainingList(
      {required TrainingRequestModel trainingRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await TrainingListDataService.trainingList(trainingRequestModel: trainingRequestModel);
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        TrainingResponse trainingResponse = TrainingResponse.fromJson(responseJson);
        for (int i = 0; i < trainingResponse.list.length; i++) {
          debugPrint("id: ${trainingResponse.list[i]}, is interval empty: ${trainingResponse.list[i].intervall!.length}");
          if(trainingResponse.list[i].intervall!.isNotEmpty){
            int cumulativeInterval = 0;
            for (int j = 0; j < trainingResponse.list[i].intervall!.length; j++) {
              List<int> intervalSeconds = [];
              if(trainingResponse.list[i].intervallBeschriftungEnglisch!.first.toString().contains("breathe in")){
                trainingResponse.list[i].isBreathInterval = true;
              } else {
                if(trainingResponse.list[i].intervall!.any((element) => element > 10)){
                  trainingResponse.list[i].isBreathInterval = true;
                }
              }
              if (j == 0){
                intervalSeconds = List.generate(trainingResponse.list[i].intervall![j], (k) => k);
              } else {
                intervalSeconds = List.generate(trainingResponse.list[i].intervall![j], (k) => cumulativeInterval + k);
              }
              cumulativeInterval += trainingResponse.list[i].intervall![j];

              trainingResponse.list[i].intervalCombinedData!.add(CombinedIntervalData(
                id: j,
                interval: trainingResponse.list[i].intervall![j],
                germanText:  trainingResponse.list[i].intervallBeschriftung![j],
                englishText: trainingResponse.list[i].intervallBeschriftungEnglisch![j],
                audioSeconds: cumulativeInterval,
                secondsList: intervalSeconds,
              ));
            }
            // debugPrint("intervals ID: ${trainingResponse.list[i].id} Ex-Audio: ${trainingResponse.list[i].dauerBeispiel} Audio: ${trainingResponse.list[i].dauerAudio} isCount: ${trainingResponse.list[i].isBreathInterval}\nlist:${trainingResponse.list[i].intervalCombinedData}");
          }
        }
        int totalExampleDuration = trainingResponse.list.fold(0, (sum, sheet) => sum + sheet.dauerBeispiel!);
        int totalAudioDuration = trainingResponse.list.fold(0, (sum, sheet) => sum + sheet.dauerAudio!);
        int totalTrainingDuration = totalExampleDuration + totalAudioDuration;
        // debugPrint("loop time is for Example: $totalExampleDuration and Audio ${totalAudioDuration} and Total: $totalTrainingDuration");
        trainingResponse.totalTrainingTime = totalTrainingDuration;
        if (response.statusCode == 200) {
            return Right(trainingResponse);
        } else if (response.statusCode == 401) {
          return (Left(AppExceptions.handle(
              int.parse(response.statusCode.toString()),
              isRefreshTokenValid: true, message: "unAuthenticated").failure));
        } else {
          return Left(Failure(0, "failed", false));
        }
      } catch (error) {
        return Left(DataSource.FromBE.getFailure(message: error.toString()));
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure(message: ''));
    }
  }
  static Future<Either<Failure, CommonResponseModel>> contactUs(
      {required ContactUsRequestModel contactUsRequestModel}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await TrainingListDataService.contactUs(
            contactUsRequestModel: contactUsRequestModel);
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        CommonResponseModel contactUsResponseModel =
        CommonResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          return Right(contactUsResponseModel);
        } else if (response.statusCode == 401) {
          return (Left(AppExceptions.handle(
              int.parse(response.statusCode.toString()),
              isRefreshTokenValid: true,
              callApiAgain: (){
                return contactUs(contactUsRequestModel: contactUsRequestModel);
              },
              message: contactUsResponseModel.message!)
              .failure));
        } else {
          return Left(Failure(0, contactUsResponseModel.message!, false));
        }
      } catch (error) {
        return Left(DataSource.FromBE.getFailure(message: error.toString()));
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure(message: ''));
    }
  }
}