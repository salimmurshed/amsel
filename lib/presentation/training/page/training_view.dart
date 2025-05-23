import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import '../../../common/resources/training_resources.dart';
import '../../../common/widgets/action_button.dart';
import '../../../common/widgets/alert_dialog.dart';
import '../../../data/model/api_response_models/interval_data.dart';
import '../../../imports/common.dart';
import '../../../main.dart';
import '../bloc/audio_player_handler.dart';
import '../bloc/training_bloc.dart';
import '../widget/volume_adjust.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({super.key});

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    BlocProvider.of<TrainingBloc>(context).add(FetchTrainingDetailEvent());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {}
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: CustomAppBar(
            isLeading: false,
            title: AppLocalizations.of(context)!.training_appbar_title,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: screenHPadding),
                child: CustomButton(
                  height:  32.h,
                  buttonSize: ButtonSize.small,
                  // width: MediaQuery.of(context).size.width / 2.2,
                  variant: ButtonVariant.btnPrimary,
                  text: AppLocalizations.of(context)!.training_doneBtn,
                  onTap: () {
                    dialog();
                  },
                ),
              )
            ],
          ),
          body: BlocConsumer<TrainingBloc, TrainingInitialState>(
            listener: (context, state) {
              if (state.isChallengeCompleted) {
                dialog();
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                      child: Stack(
                    children: [
                      Container(
                        color: AppColor.colorWhite,
                      ),
                      state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state.isFailure
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Expanded(
                                        child: Stack(
                                      children: [
                                        const Positioned(
                                            bottom: -50,
                                            right: 0,
                                            child: ImageView(
                                              imagePath: Assets.icBottomBG,
                                            )),
                                        StreamBuilder<MediaItem?>(
                                          stream: audioPlayerHandler.mediaItem,
                                          builder: (context, snapshot) {
                                            var data = snapshot.data;
                                            if (data == null) {
                                              return const SizedBox();
                                            }
                                            final metadata = data;
                                            List<CombinedIntervalData>
                                                interval =
                                                metadata.extras!["interval"];
                                            return Column(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: interval.isNotEmpty
                                                        ? IntervalStreamView(
                                                            intervals: interval,
                                                            locale:
                                                                state.locale)
                                                        : Center(
                                                            child: metadata.extras![
                                                                        'image'] ==
                                                                    ""
                                                                ? Image.asset(
                                                                    Assets
                                                                        .icAppIconColored,
                                                                    height:
                                                                        153.h,
                                                                    width:
                                                                        153.w)
                                                                : Image.network(
                                                                    metadata.extras![
                                                                        'image'])),
                                                  ),
                                                ),
                                                StreamBuilder<QueueState?>(
                                                    stream: audioPlayerHandler
                                                        .queueState,
                                                    builder:
                                                        (context, snapshot) {
                                                      final data =
                                                          snapshot.data;
                                                      final sequence =
                                                          data?.queue ?? [];
                                                      final currentIndex =
                                                          data?.queueIndex ?? 0;
                                                      final isExample = sequence
                                                              .isNotEmpty
                                                          ? sequence[currentIndex]
                                                                      .extras![
                                                                  'isExample'] ==
                                                              true
                                                          : false;
                                                      final hasExample = sequence
                                                              .isNotEmpty
                                                          ? sequence[currentIndex]
                                                                      .extras![
                                                                  'hasExample'] ==
                                                              true
                                                          : false;
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          hasExample
                                                              ? Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              screenHPadding),
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      if (isExample) {
                                                                        // Skip to the next track
                                                                        audioPlayerHandler
                                                                            .player
                                                                            .seekToNext();
                                                                      } else {
                                                                        // Repeat the previous track
                                                                        audioPlayerHandler
                                                                            .player
                                                                            .seekToPrevious();
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        margin: EdgeInsets.symmetric(vertical: menuCardVerticalPadding),
                                                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                                                        decoration: BoxDecoration(color: isExample ? AppColor.colorLightGrey : AppColor.colorPrimary, borderRadius: BorderRadius.circular(iconContainerRadius)),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            ImageView(
                                                                                svgPath: Assets.icRepeat,
                                                                                color: isExample ? AppColor.colorTextLightBG : AppColor.colorWhite),
                                                                            SizedBox(width: 10.w),
                                                                            Text(
                                                                              isExample ? AppLocalizations.of(context)!.training_skip_example : AppLocalizations.of(context)!.training_repeat_example,
                                                                              style: Style.buttonLabel(color: isExample ? AppColor.colorTextLightBG : AppColor.colorWhite),
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ))
                                                              : Container(),
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          screenHPadding),
                                                              child:
                                                                  actionButtonIcon(
                                                                isInfo: true,
                                                                color: AppColor
                                                                    .colorWhite,
                                                                svgPath: Assets
                                                                    .icInfo,
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) {
                                                                        audioPlayerHandler
                                                                            .player
                                                                            .pause();
                                                                        return CustomAlertDialog(
                                                                          title:
                                                                              AppLocalizations.of(context)!.training_challenge_info_title,
                                                                          subTitle: state.locale == const Locale("de")
                                                                              ? sequence[currentIndex].extras!['info_text_de']
                                                                              : sequence[currentIndex].extras!['info_text_en'],
                                                                          isOk:
                                                                              true,
                                                                          btnText:
                                                                              AppLocalizations.of(context)!.confirmationDialog_okBtn,
                                                                          onTapOkButton:
                                                                              () {
                                                                            audioPlayerHandler.player.play();
                                                                            Navigator.pop(context);
                                                                          },
                                                                        );
                                                                      }).then((value) {
                                                                    audioPlayerHandler
                                                                        .player
                                                                        .play();
                                                                  });
                                                                },
                                                              )),
                                                        ],
                                                      );
                                                    }),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                                  ],
                                )
                    ],
                  )),
                  state.isLoading
                      ? const SizedBox()
                      : Container(
                          width: double.infinity,
                          decoration: Style.bottomSheetDecoration(
                              color: AppColor.colorLightGrey),
                          padding: EdgeInsets.symmetric(
                              vertical: screenVPadding,
                              horizontal: screenHPadding),
                          child: Column(
                            children: [
                              StreamBuilder<QueueState?>(
                                  stream: audioPlayerHandler.queueState,
                                  builder: (context, snapshot) {
                                    final data = snapshot.data;
                                    if (data?.queue.isEmpty ?? true) {
                                      return const SizedBox();
                                    }
                                    final queue = data?.queue ?? [];
                                    final currentIndex = data?.queueIndex ?? 0;
                                    final metadata = queue[currentIndex];
                                    return data == null || queue.isEmpty
                                        ? Container()
                                        : Column(
                                            children: [
                                              CircleIndicator(
                                                  queue: queue,
                                                  currentIndex: currentIndex),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.h),
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: metadata.title,
                                                          style: Style
                                                              .subTitleBoldStyle()),
                                                      // TextSpan(
                                                      //   text:
                                                      //       ' (${formatDurationWithMinAndSec(audioPlayerHandler.player.duration ?? Duration.zero)}) ',
                                                      //   style: Style
                                                      //       .descTextStyle(),
                                                      // ),
                                                      metadata.extras == null
                                                          ? const TextSpan()
                                                          : TextSpan(
                                                              text:
                                                                  ' ${metadata.extras!["hasExample"] == true ? metadata.extras!["isExample"] ? '- ${AppLocalizations.of(context)!.training_example}' : '' : ''} ',
                                                              style: Style
                                                                  .descTextStyle(),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                  }),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: menuCardVerticalPadding),
                                        StreamBuilder<PositionData>(
                                          stream: positionDataStream(),
                                          builder: (context, snapshot) {
                                            final positionData = snapshot.data;
                                            return SeekBar(
                                              duration:
                                                  positionData?.duration ??
                                                      Duration.zero,
                                              position:
                                                  positionData?.position ??
                                                      Duration.zero,
                                              bufferedPosition: positionData
                                                      ?.bufferedPosition ??
                                                  Duration.zero,
                                              onChangeEnd: (newPosition) {
                                                audioPlayerHandler
                                                    .seek(newPosition);
                                              },
                                            );
                                          },
                                        ),
                                        SizedBox(height: 10.h),
                                        StreamBuilder<Duration?>(
                                          stream: audioPlayerHandler
                                              .player.durationStream,
                                          builder: (context, durationSnapshot) {
                                            final totalDuration =
                                                durationSnapshot.data ??
                                                    Duration.zero;
                                            return StreamBuilder<Duration>(
                                              stream: audioPlayerHandler
                                                  .player.positionStream,
                                              builder:
                                                  (context, positionSnapshot) {
                                                final currentPosition =
                                                    positionSnapshot.data ??
                                                        Duration.zero;
                                                final remainingTime =
                                                    totalDuration -
                                                        currentPosition;
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // Display the current position
                                                    Text(
                                                      _formatDuration(
                                                          currentPosition),
                                                    ),
                                                    // Display the remaining time
                                                    Text(
                                                      '-${_formatDuration(remainingTime)}',
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<double>(
                                      stream: audioPlayerHandler.speed,
                                      builder: (context, snapshot) {
                                        return GestureDetector(
                                          onTap: () {
                                            showSliderDialog(
                                                context: context,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .training_adjust_speed_title,
                                                divisions: 4,
                                                min: 0.8,
                                                max: 1.2,
                                                stream:
                                                    audioPlayerHandler.speed,
                                                onChanged:
                                                    audioPlayerHandler.setSpeed,
                                                value: audioPlayerHandler
                                                    .speed.value);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                6.w, 12.h, 0, 2.h),
                                            decoration: BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(
                                                color: AppColor.colorLightGrey,
                                                width: 1.0,
                                              ),
                                            )),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${snapshot.data?.toStringAsFixed(1)}x",
                                                  style:
                                                      Style.infoTextBoldStyle(),
                                                ),
                                                SizedBox(width: 10.w),
                                                const ImageView(
                                                    svgPath:
                                                        Assets.icDownArrowFill)
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                              ControlButtons(audioHandler: audioPlayerHandler),
                              SizedBox(
                                  height: Platform.isIOS
                                      ? widgetBottomPadding
                                      : null),
                            ],
                          ),
                        )
                ],
              );
            },
          )),
    );
  }

  Stream<Duration> bufferedPositionStream() {
    return audioPlayerHandler.playbackState
        .map((state) => state.bufferedPosition)
        .distinct();
  }

  Stream<Duration?> durationStream() {
    return audioPlayerHandler.mediaItem
        .map((item) => item?.duration)
        .distinct();
  }

  Stream<PositionData> positionDataStream() {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        AudioService.position,
        bufferedPositionStream(),
        durationStream(),
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future dialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomAlertDialog(
              title:
                  AppLocalizations.of(context)!.training_completed_dialog_title,
              subTitle:
                  AppLocalizations.of(context)!.training_completed_dialog_desc,
              btnText:
                  AppLocalizations.of(context)!.training_repeat_challenge_btn,
              onTapEndButton: () {
                BlocProvider.of<TrainingBloc>(context)
                    .add(TriggerChallengeDone());
              },
              isDone: true,
              onTapButton: () {
                BlocProvider.of<TrainingBloc>(context)
                    .add(TriggerRepeatChallenge());
              },
            ));
  }
}

class IntervalCard extends StatelessWidget {
  final CombinedIntervalData intervalData;
  final int currentInterval;
  final Locale locale;

  const IntervalCard(
      {super.key,
      required this.intervalData,
      required this.currentInterval,
      required this.locale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 48.w,
      ),
      child: Container(
        // decoration: Style.containerShadowDecoration(radius: containerRadius),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.colorVeryLightGrey,
          borderRadius: BorderRadius.circular(containerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 16,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
            vertical: screenVPadding, horizontal: menuCardHorizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.training_breathing_exercise,
                style: Style.descTextStyle()),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Container(
                height: 60.h,
                width: 60.w,
                decoration: BoxDecoration(
                  color: AppColor.colorPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.colorWhite, width: 2.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                    currentInterval.toString(), // Display the current interval
                    style: Style.titleStyle(color: AppColor.colorTextDarkBG)),
              ),
            ),
            Text(
                locale == const Locale("de")
                    ? intervalData.germanText
                    : intervalData.englishText,
                style: Style.descTextBoldStyle()),
          ],
        ),
      ),
    );
  }
}

class IntervalStreamView extends StatelessWidget {
  final List<CombinedIntervalData> intervals;
  final Locale locale;

  const IntervalStreamView(
      {super.key, required this.intervals, required this.locale});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: audioPlayerHandler.player.positionStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final position = snapshot.data ?? Duration.zero;

        // Initialize variables to hold current interval data
        CombinedIntervalData? currentIntervalData;
        int currentInterval = 0;

        // Reverse the order of intervals
        for (var i = intervals.length - 1; i >= 0; i--) {
          final interval = intervals[i];
          for (int j = interval.secondsList.length - 1; j >= 0; j--) {
            if (position.inSeconds >= interval.secondsList[j]) {
              currentIntervalData = interval;
              currentInterval = interval.secondsList.length - j;
              break;
            }
          }
          if (currentIntervalData != null) {
            break; // Break outer loop if we found the current interval
          }
        }

        // If no interval matched, use the first one
        currentIntervalData ??= intervals.first;
        if (currentInterval == 0) {
          currentInterval = currentIntervalData.secondsList.length;
        }

        return Center(
          child: IntervalCard(
            intervalData: currentIntervalData,
            currentInterval: currentInterval,
            locale: locale,
          ),
        );
      },
    );
  }
}

class CircleIndicator extends StatelessWidget {
  final List<MediaItem> queue;
  final int currentIndex;

  const CircleIndicator({
    super.key,
    required this.queue,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final groupedItems = _groupById(queue);
    return queue.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < groupedItems.length; i++)
                    _buildCircle(groupedItems[i], i),
                ],
              ),
            ],
          );
  }

  // Function to group items by 'id'
  List<List<MediaItem>> _groupById(List<MediaItem> items) {
    List<List<MediaItem>> groupedItems = [];
    List<MediaItem> currentGroup = [];

    for (var item in items) {
      final id = item.extras!['id'];
      if (currentGroup.isEmpty || currentGroup.last.extras!['id'] == id) {
        currentGroup.add(item);
      } else {
        groupedItems.add(currentGroup);
        currentGroup = [item];
      }
    }

    if (currentGroup.isNotEmpty) {
      groupedItems.add(currentGroup);
    }

    return groupedItems;
  }

  Widget _buildCircle(List<MediaItem> group, int groupIndex) {
    // Determine if the group is completed or currently playing
    bool isCurrent = group.any((item) => queue.indexOf(item) == currentIndex);

    // Determine if the group is completed
    bool isCompleted =
        group.every((item) => queue.indexOf(item) < currentIndex);

    // Set circle color based on status
    Color color;
    if (isCurrent) {
      color = AppColor.colorPrimary;
    } else if (isCompleted) {
      color = AppColor.colorSecondaryText;
    } else {
      color = AppColor.colorLightGrey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(
        Icons.circle,
        color: color,
        size: 18,
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayerHandler audioHandler;

  const ControlButtons({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<QueueState>(
            stream: audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data;
              return GestureDetector(
                onTap: () {
                  skipToPrevious();
                },
                child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(
                        0, 5.h, menuCardHorizontalPadding, 5.h),
                    child: const ImageView(svgPath: Assets.icBackward)),
              );
            }),
        StreamBuilder<QueueState>(
          stream: audioHandler.queueState,
          builder: (context, snapshot) => GestureDetector(
            onTap: audioHandler.rewind,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: const ImageView(
                svgPath: Assets.icBackSkip,
              ),
            ),
          ),
        ),
        StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, snapshot) {
            final playbackState = snapshot.data;
            final processingState = playbackState?.processingState;
            final playing = playbackState?.playing;
            if (processingState == AudioProcessingState.loading ||
                processingState == AudioProcessingState.buffering) {
              return Container(
                padding:  EdgeInsets.all(6.r),
                height:  40.h,
                width: isTablet? 30.w: 40.w,
                child: CircularProgressIndicator(
                  color: AppColor.colorPrimary,
                ),
              );
            } else if (playing != true) {
              return GestureDetector(
                onTap: audioHandler.play,
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.colorPrimary,
                    ),
                    height: 40.h,
                    width: 40.w,
                    child: Icon(Icons.play_arrow_rounded,
                        color: AppColor.colorWhite, size: 30)),
              );
            } else {
              return GestureDetector(
                onTap: audioHandler.pause,
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.colorPrimary,
                    ),
                    height: 40.h,
                    width: 40.w,
                    child: Icon(Icons.pause,
                        color: AppColor.colorWhite, size: 30)),
              );
            }
          },
        ),
        StreamBuilder<QueueState>(
          stream: audioHandler.queueState,
          builder: (context, snapshot) => GestureDetector(
            onTap: audioHandler.fastForward,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: const ImageView(svgPath: Assets.icForwardSkip),
            ),
          ),
        ),
        const SkipButton(),
      ],
    );
  }

  skipToPrevious() async {
    final currentIndex = audioHandler.player.currentIndex;
    if (currentIndex == null) return Future.value();

    final queue = audioHandler.queue.value;
    if (queue.isEmpty) return Future.value();

    // Get the current track ID
    final currentTrackId = queue[currentIndex].extras!['id'];

    // Find the index of the previous track that doesn't have the same ID
    int previousIndex = currentIndex - 1;
    while (previousIndex >= 0) {
      final previousTrackId = queue[previousIndex].extras!['id'];
      if (previousTrackId != currentTrackId) {
        break;
      }
      previousIndex--;
    }

    // If we've reached the beginning of the queue or all previous tracks have the same ID
    if (previousIndex <= 0) {
      await audioHandler.player.seek(Duration.zero, index: 0);
      // await stop();  // Or any other appropriate action
      return;
    }

    // Seek to the previous valid track
    final effectiveIndex = audioHandler.player.shuffleModeEnabled
        ? audioHandler.player.shuffleIndices![previousIndex]
        : previousIndex;

    await audioHandler.player.seek(Duration.zero, index: effectiveIndex);
  }
}

class SkipButton extends StatefulWidget {
  const SkipButton({super.key});

  @override
  State<SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<SkipButton> with WidgetsBindingObserver {
  bool _isAppInForeground = true;
  final ValueNotifier<bool> isButtonDisabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _isAppInForeground = true;
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _isAppInForeground = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isButtonDisabled,
      builder: (context, isButtonDisabled, child) {
        return StreamBuilder<QueueState>(
          stream: audioPlayerHandler.queueState,
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: handleButtonPress,
              child: Container(
                color: Colors.transparent,
                padding:
                    EdgeInsets.fromLTRB(menuCardHorizontalPadding, 5.h, 0, 5.h),
                child: ImageView(
                    svgPath: Assets.icForward,
                    color: isButtonDisabled ? Colors.grey : null),
              ),
            );
          },
        );
      },
    );
  }

  void handleButtonPress() async {
    if (isButtonDisabled.value && !audioPlayerHandler.player.hasNext) {
      return; // Prevent button press if disabled
    }
    if (audioPlayerHandler.player.hasNext) {
      skipToNext();
    } else {
      isButtonDisabled.value = true; // Disable button
      if (_isAppInForeground) {
        BlocProvider.of<TrainingBloc>(context).add(TriggerPlayerCompleted());
      } else {
        audioPlayerHandler.player.stop();
        audioPlayerHandler.player.seek(Duration.zero);
      }
    }
  }

  skipToNext() async {
    final currentIndex = audioPlayerHandler.player.currentIndex;
    if (currentIndex == null) return;

    final queue = audioPlayerHandler.queue.value;
    if (queue.isEmpty) return;

    // Get the current track ID
    final currentTrackId = queue[currentIndex].extras!['id'];

    // Find the index of the next track with a different ID
    int nextIndex = currentIndex + 1;
    while (nextIndex < queue.length) {
      final nextTrackId = queue[nextIndex].extras!['id'];
      if (nextTrackId != currentTrackId) {
        break; // Found a track with a different ID
      }
      nextIndex++;
    }

    // Check if we need to complete the playlist
    if (nextIndex >= queue.length) {
      // If all remaining tracks have the same ID as the current track
      final nextTrackId = queue[nextIndex - 1].extras!['id'];
      if (nextTrackId == currentTrackId) {
        await audioPlayerHandler
            .stop(); // Or perform any other action to complete the playlist
        BlocProvider.of<TrainingBloc>(context).add(TriggerPlayerCompleted());
        return;
      } else {
        debugPrint("not matching");
      }
    }

    // Seek to the next valid track
    if (nextIndex < queue.length) {
      final effectiveIndex = audioPlayerHandler.player.shuffleModeEnabled
          ? audioPlayerHandler.player.shuffleIndices![nextIndex] ?? nextIndex
          : nextIndex;

      await audioPlayerHandler.player
          .seek(Duration.zero, index: effectiveIndex);
    }
  }
}
