import 'dart:async';
import 'dart:io';
import 'package:amsel_flutter/imports/common.dart';
import 'package:amsel_flutter/main.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../common/resources/training_constants.dart';
import '../../../data/model/api_request_models/training_request_model.dart';
import '../../../data/model/api_response_models/training_response.dart';
import '../../../data/repository/local_products_repository.dart';
import '../../../data/repository/repository_dependencies.dart';
import '../../../services/share_preferences_services/training_data.dart';
import '../usecase/training_usecase.dart';

part 'training_event.dart';

part 'training_state.dart';

part 'training_bloc.freezed.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingInitialState> {
  final TrainingUseCase trainingUseCase;
  bool isCompleted = false;
  DateTime startTime = DateTime.now();
  TrainingBloc(this.trainingUseCase)
      : super(TrainingInitialState.initial()) {
    // Initialize the audio handler
    audioPlayerHandler.playbackState.listen((playerState) async {
      // print("object play state ${playerState.processingState}");
      print("object play state ${audioPlayerHandler.player.duration}");
      if (playerState.processingState == AudioProcessingState.completed) {
        if (!isCompleted) {
          isCompleted = true;
          add(TriggerPlayerCompleted());
        }
      }
    });
    on<FetchTrainingDetailEvent>(_onFetchTrainingDetailEvent);
    on<TriggerPlayerCompleted>(_onTriggerPlayerCompleted);
    on<TriggerChallengeDone>(_onTriggerChallengeDone);
    on<TriggerRepeatChallenge>(_onTriggerRepeatChallenge);
  }

  FutureOr<void> _onFetchTrainingDetailEvent(FetchTrainingDetailEvent event, Emitter<TrainingInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    int count =
    await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
    print("detail object count: $count");
    count = count + 1;
    print("repeat counter: $count");
    await RepositoryDependencies.appSettingsData.setLeftTrainingCount(value: count);
    int updatedCount = await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
    print("detail object updated count: $updatedCount");
    emit(state.copyWith(isLoading: true));
    TrainingData trainingData =  RepositoryDependencies.trainingData;
    String type = await trainingData.geTrainingType();
    String level = await trainingData.getTrainingLevel();
    String range = await trainingData.getTrainingRange();
    String focus = await trainingData.getTrainingFocus();
    TrainingRequestModel trainingRequestModel = TrainingRequestModel(
        duration: TrainingConstants.durationSeconds,
        level: level,
        type: type,
        voice: range,
        focus: focus);
    try {
      final response = await trainingUseCase.execute(trainingRequestModel);
      await response.fold((failure) async {
        Navigator.pop(navigatorKey.currentContext!);
        Toast.nullableIconToast(
            message: failure.message, isErrorBooleanOrNull: null);
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
        ));
      }, (success) async {
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.music());
        //
        // debugPrint("TrainingResponse total time: ${success.totalTrainingTime}");
        List<MediaItem> playlist = await createPlaylist(success: success);
        await audioPlayerHandler.resetAndInit(playlist);
        Duration totalDuration = Duration.zero;
        for (var source in playlist) {
          totalDuration += source.duration ?? Duration.zero;
        }
        audioPlayerHandler.play();
        startTime = DateTime.now();
        emit(state.copyWith(
          isLoading: false,
          isFailure: false,
          totalTrainingTime: totalDuration,
        ));
      });
    } catch (e) {
      debugPrint("Error: $e");
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
      ));
    }
  }

  Future<List<MediaItem>> createPlaylist({required TrainingResponse success}) async {
    List<MediaItem> mediaItems = [];
    final File imageFile = await getLocalImageFile(Assets.icColoredAppIcon);
    for (var element in success.list) {
      bool hasExample = element.audiodatei != null && element.audiodatei!.isNotEmpty;
      // debugPrint("hasExample: $hasExample");
      if (element.beispielAudio != null && element.beispielAudio!.isNotEmpty) {
        mediaItems.add(MediaItem(
            id: element.beispielAudio.toString(),
            title: element.text!,
            duration: Duration(seconds: element.dauerBeispiel!),
            artUri: Uri.file(imageFile.path),
            extras: {
              'id': element.id,
              'isExample': true,
              'hasExample': hasExample,
              'isAudioCompleted': false,
              'interval': element.intervalCombinedData ?? [],
              'info_text_en': element.beschreibungEnglish,
              'info_text_de': element.beschreibung,
              'image': element.grafik ?? ""
            }));
      }
      if (element.audiodatei != null && element.audiodatei!.isNotEmpty) {
        // Add MediaItem with audiodatei
        mediaItems.add(MediaItem(
            id: element.audiodatei.toString(),
            title: element.text!,
            duration: Duration(seconds: element.dauerAudio!),
            artUri: Uri.file(imageFile.path),
            extras: {
              'id': element.id,
              'hasExample': hasExample,
              'isExample': false,
              'isAudioCompleted': false,
              'interval': element.intervalCombinedData ?? [],
              'info_text_en': element.beschreibungEnglish,
              'info_text_de': element.beschreibung,
              'image': element.grafik ?? ""
            }));
      }
    }
    return mediaItems;
  }

  FutureOr<void> _onTriggerChallengeDone(TriggerChallengeDone event, Emitter<TrainingInitialState> emit) async {
    emit(state.copyWith(isLoading: true, isChallengeCompleted: false));
    await saveTrainingData();
    isCompleted = false;
    emit(state.copyWith(isLoading: false));
    await audioPlayerHandler.stop();
    if(Platform.isAndroid) {
      await audioPlayerHandler.stopForAndroid();
    }
    Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, RouteName.routeParentNavigation, (route) => false);
  }

  FutureOr<void> _onTriggerRepeatChallenge(TriggerRepeatChallenge event, Emitter<TrainingInitialState> emit) async {
    emit(state.copyWith(isLoading: true, isChallengeCompleted: false));
    Navigator.pop(navigatorKey.currentContext!);
    try {
      int count =
      await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
      print("repeat detail object count: $count");
      count = count + 1;
      print("repeat counter: $count");
      await RepositoryDependencies.appSettingsData.setLeftTrainingCount(value: count);
      int updatedCount = await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
      print("repeat detail object updated count: $updatedCount");
      await saveTrainingData();
      await audioPlayerHandler.player.seek(Duration.zero, index: 0);
      await audioPlayerHandler.replay();
      audioPlayerHandler.play(); // Start playback
      emit(state.copyWith(
        isLoading: false,
        isFailure: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
      ));
    }
  }

  FutureOr<void> _onTriggerPlayerCompleted(TriggerPlayerCompleted event, Emitter<TrainingInitialState> emit) async {
    emit(state.copyWith(isChallengeCompleted: true));
  }

  saveTrainingData() async {
    Duration cumulativeDuration = Duration.zero;
    cumulativeDuration +=
        audioPlayerHandler.player.duration ?? Duration.zero;

    debugPrint("startTime: $startTime and end Time ${DateTime.now()}");
    Duration difference = DateTime.now().difference(startTime);
    debugPrint("difference: $difference");
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(difference.inMinutes);
    String seconds = twoDigits(difference.inSeconds.remainder(60));

    debugPrint('duration $minutes:$seconds');
    String type = await GetDashboardSelectedData.getTypeValue();
    String level = await GetDashboardSelectedData.getLevelValue();
    String range = await GetDashboardSelectedData.getRangeValue();
    String focus = await GetDashboardSelectedData.getFocusValue();
    String typeServerId =
    await RepositoryDependencies.trainingData.geTrainingType();
    String levelServerId =
    await RepositoryDependencies.trainingData.getTrainingLevel();
    String rangeServerId =
    await RepositoryDependencies.trainingData.getTrainingRange();
    String focusServerId =
    await RepositoryDependencies.trainingData.getTrainingFocus();
    await LocalTrainingRepository.addTraining(
        date: startTime,
        duration: TrainingConstants.durationSeconds.round().toString(),
        type: type,
        level: level,
        range: range,
        focus: focus,
        typeServerId: typeServerId,
        levelServerId: levelServerId,
        rangeServerId: rangeServerId,
        focusServerId: focusServerId,
        totalTrainingTime: state.totalTrainingTime.inSeconds.round(),
        totalAttendedTrainingTime: difference.inSeconds.round());
  }
}