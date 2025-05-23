// import 'dart:io';
// import 'package:amsel_flutter/imports/training_resources.dart';
// import 'package:amsel_flutter/presentation/training_one/bloc/training_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:rxdart/rxdart.dart';
// import '../data/model/api_response_models/interval_data.dart';
// import '../presentation/training/widget/volume_adjust.dart';
// import '../presentation/training_one/training_new.dart';
// import 'training_resources.dart';
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   MyAppState createState() => MyAppState();
// }
//
// class MyAppState extends State<MyApp> {
//   Duration cumulativeDuration = Duration.zero;
//
//   @override
//   void initState() {
//     BlocProvider.of<TrainingBloc>(context).add(FetchTrainingDetailEvent());
//     super.initState();
//   }
//
//   Stream<PositionData> _positionDataStream(AudioPlayer audioPlayer) {
//     return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//         audioPlayer.positionStream,
//         audioPlayer.bufferedPositionStream,
//         audioPlayer.durationStream,
//         // (position, bufferedPosition, duration) =>
//         // PositionData(
//         //     position, bufferedPosition, duration ?? Duration.zero));
//         (position, bufferedPosition, duration) {
//       // Update cumulative duration
//       if (position > cumulativeDuration) {
//         setState(() {
//           cumulativeDuration = position;
//         });
//       }
//       return PositionData(
//           position, bufferedPosition, duration ?? Duration.zero);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: SafeArea(
//           child: BlocConsumer<TrainingBloc, TrainingInitialState>(
//               listener: (context, state) {},
//               builder: (context, state) {
//                 return state.isLoading ? const Center(child: CircularProgressIndicator()) : Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: StreamBuilder<SequenceState?>(
//                         stream: state.audioPlayer.sequenceStateStream,
//                         builder: (context, snapshot) {
//                           final data = snapshot.data;
//                           if (data?.sequence.isEmpty ?? true) {
//                             return const SizedBox();
//                           }
//                           final metadata =
//                           data!.currentSource!.tag as MediaItem;
//                           List<CombinedIntervalData> interval = metadata.extras!["interval"];
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: interval.isNotEmpty
//                                       ? IntervalStreamView(
//                                   intervals: interval,
//                                   audioPlayer: state.audioPlayer,
//                                     locale: state.locale,
//                                   )
//                                       : Center(
//                                       child: metadata.artUri
//                                           .toString()
//                                           .contains("file")
//                                           ? Image.file(
//                                           File.fromUri(metadata.artUri!))
//                                           : Image.network(
//                                           metadata.artUri.toString())),
//                                 ),
//                               ),
//                               Text(metadata.title,
//                                   style:
//                                       Theme.of(context).textTheme.titleLarge),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     ControlButtons(player: state.audioPlayer),
//                     StreamBuilder<PositionData>(
//                       stream: _positionDataStream(state.audioPlayer),
//                       builder: (context, snapshot) {
//                         final positionData = snapshot.data;
//                         return SeekBar(
//                           duration: positionData?.duration ?? Duration.zero,
//                           position: positionData?.position ?? Duration.zero,
//                           bufferedPosition:
//                               positionData?.bufferedPosition ?? Duration.zero,
//                           onChangeEnd: (newPosition) {
//                             state.audioPlayer.seek(newPosition);
//                           },
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 8.0),
//                     StreamBuilder<Duration?>(
//                       stream: state.audioPlayer.durationStream,
//                       builder: (context, durationSnapshot) {
//                         final totalDuration = durationSnapshot.data ?? Duration.zero;
//                         return StreamBuilder<Duration>(
//                           stream: state.audioPlayer.positionStream,
//                           builder: (context, positionSnapshot) {
//                             final currentPosition = positionSnapshot.data ?? Duration.zero;
//                             final remainingTime = totalDuration - currentPosition;
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // Display the current position
//                                 Text(
//                                   _formatDuration(currentPosition),
//                                   style: TextStyle(fontSize: 16.0),
//                                 ),
//                                 SizedBox(width: 8.0),
//                                 // Display the remaining time
//                                 Text(
//                                   '-${_formatDuration(remainingTime)}',
//                                   style: TextStyle(fontSize: 16.0),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//
//                     Row(
//                       children: [
//                         StreamBuilder<LoopMode>(
//                           stream: state.audioPlayer.loopModeStream,
//                           builder: (context, snapshot) {
//                             final loopMode = snapshot.data ?? LoopMode.off;
//                             const icons = [
//                               Icon(Icons.repeat, color: Colors.grey),
//                               Icon(Icons.repeat, color: Colors.orange),
//                               Icon(Icons.repeat_one, color: Colors.orange),
//                             ];
//                             const cycleModes = [
//                               LoopMode.off,
//                               LoopMode.all,
//                               LoopMode.one,
//                             ];
//                             final index = cycleModes.indexOf(loopMode);
//                             return IconButton(
//                               icon: icons[index],
//                               onPressed: () {
//                                 state.audioPlayer.setLoopMode(cycleModes[
//                                     (cycleModes.indexOf(loopMode) + 1) %
//                                         cycleModes.length]);
//                               },
//                             );
//                           },
//                         ),
//                         Expanded(
//                           child: Text(
//                             "Playlist",
//                             style: Theme.of(context).textTheme.titleLarge,
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         StreamBuilder<bool>(
//                           stream: state.audioPlayer.shuffleModeEnabledStream,
//                           builder: (context, snapshot) {
//                             final shuffleModeEnabled = snapshot.data ?? false;
//                             return IconButton(
//                               icon: shuffleModeEnabled
//                                   ? const Icon(Icons.shuffle,
//                                       color: Colors.orange)
//                                   : const Icon(Icons.shuffle,
//                                       color: Colors.grey),
//                               onPressed: () async {
//                                 final enable = !shuffleModeEnabled;
//                                 if (enable) {
//                                   await state.audioPlayer.shuffle();
//                                 }
//                                 await state.audioPlayer
//                                     .setShuffleModeEnabled(enable);
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     StreamBuilder<SequenceState?>(
//                         stream: state.audioPlayer.sequenceStateStream,
//                         builder: (context, snapshot) {
//                           final data = snapshot.data;
//                           final sequence = data?.sequence ?? [];
//                           final currentIndex = data?.currentIndex ?? 0;
//                           final isExample = sequence.isNotEmpty
//                               ? sequence[currentIndex]
//                                       .tag
//                                       .extras!['isExample'] ==
//                                   true
//                               : false;
//                           return Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (isExample) {
//                                   // Skip to the next track
//                                   state.audioPlayer.seekToNext();
//                                 } else {
//                                   // Repeat the current track
//                                   state.audioPlayer.seekToPrevious();
//                                 }
//                               },
//                               child: Text(isExample ? 'Skip Audio' : 'Repeat'),
//                             ),
//                           );
//                         }),
//                     StreamBuilder<SequenceState?>(
//                         stream: state.audioPlayer.sequenceStateStream,
//                         builder: (context, snapshot) {
//                           final data = snapshot.data;
//                           final sequence = data?.sequence ?? [];
//                           final currentIndex = data?.currentIndex ?? 0;
//                           for (var element in sequence) {
//                             // print(element.tag.extras!['id']);
//                           }
//                           return data == null ? SizedBox(): CircleIndicator(sequence: sequence, currentIndex: currentIndex);
//                         }),
//                     Expanded(
//                       child: StreamBuilder<SequenceState?>(
//                         stream: state.audioPlayer.sequenceStateStream,
//                         builder: (context, snapshot) {
//                           final data = snapshot.data;
//                           final sequence = data?.sequence ?? [];
//                           return ReorderableListView(
//                             onReorder: (int oldIndex, int newIndex) {
//                               if (oldIndex < newIndex) newIndex--;
//                               // _playlist.move(oldIndex, newIndex);
//                             },
//                             children: [
//                               for (var i = 0; i < sequence.length; i++)
//                                 Dismissible(
//                                   key: ValueKey(sequence[i]),
//                                   background: Container(
//                                     color: Colors.redAccent,
//                                     alignment: Alignment.centerRight,
//                                     child: const Padding(
//                                       padding: EdgeInsets.only(right: 8.0),
//                                       child: Icon(Icons.delete,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                   onDismissed: (dismissDirection) {
//                                     // state.audioPlayer.removeAt(i);
//                                   },
//                                   child: Material(
//                                     color: i == data!.currentIndex
//                                         ? Colors.grey.shade300
//                                         : null,
//                                     child: ListTile(
//                                       title:
//                                           Text(sequence[i].tag.title as String),
//                                       subtitle: Text(
//                                           '${sequence[i].tag.extras!['id'] ?? ''} ${sequence[i].tag.extras!['isExample'] ?? ''}'),
//                                       onTap: () {
//                                         state.audioPlayer
//                                             .seek(Duration.zero, index: i);
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//         ),
//       ),
//     );
//   }
// }
//
// String _formatDuration(Duration duration) {
//   final seconds = duration.inSeconds % 60;
//   final minutes = (duration.inSeconds ~/ 60) % 60;
//   final hours = duration.inHours;
//   return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
// }
//
// class CircleIndicator extends StatelessWidget {
//   final List<IndexedAudioSource> sequence;
//   final int currentIndex;
//
//   const CircleIndicator({
//     super.key,
//     required this.sequence,
//     required this.currentIndex,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final groupedItems = _groupById(sequence);
//
//     return sequence.isEmpty ? SizedBox() : Column(
//       children: [
//         Text('${sequence[currentIndex].tag.title} (${_formatDuration(sequence[currentIndex].duration!)})'),
//         Wrap(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             for (var i = 0; i < groupedItems.length; i++)
//               _buildCircle(groupedItems[i], i),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // Function to group items by 'id'
//   List<List<IndexedAudioSource>> _groupById(List<IndexedAudioSource> items) {
//     List<List<IndexedAudioSource>> groupedItems = [];
//     List<IndexedAudioSource> currentGroup = [];
//
//     for (var item in items) {
//       final id = item.tag.extras!['id'];
//       if (currentGroup.isEmpty || currentGroup.last.tag.extras!['id'] == id) {
//         currentGroup.add(item);
//       } else {
//         groupedItems.add(currentGroup);
//         currentGroup = [item];
//       }
//     }
//
//     if (currentGroup.isNotEmpty) {
//       groupedItems.add(currentGroup);
//     }
//
//     return groupedItems;
//   }
//
//   Widget _buildCircle(List<IndexedAudioSource> group, int groupIndex) {
//     // Determine the last index in this group
//     final lastIndexInGroup = sequence.indexOf(group.first) ;
//
//     // Determine if the group is completed or currently playing
//     bool isCurrent = group.any((item) => sequence.indexOf(item) == currentIndex);
//
//     // Determine if the group is completed
//     bool isCompleted = group.every((item) => sequence.indexOf(item) < currentIndex);
//
//
//     // Set circle color based on status
//     Color color;
//     if (isCurrent) {
//       color = AppColor.colorPrimary;
//     } else if (isCompleted) {
//       color = AppColor.colorSecondaryText;
//     } else {
//       color = AppColor.colorLightGrey;
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: Icon(
//         Icons.circle,
//         color: color,
//         size: 20.0,
//       ),
//     );
//   }
// }
//
// // Example usage
// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;
//
//   ControlButtons({super.key, required this.player});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.volume_up),
//           onPressed: () {
//             showSliderDialog(
//               value: player.volume,
//               context: context,
//               title: "Adjust volume",
//               divisions: 10,
//               min: 0.0,
//               max: 1.0,
//               stream: player.volumeStream,
//               onChanged: player.setVolume,
//             );
//           },
//         ),
//         StreamBuilder<SequenceState?>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: const Icon(Icons.skip_previous),
//             onPressed: () {
//               player.hasPrevious ? skipPreviousBasedOnId(player) : null;
//             }
//           ),
//
//         ),
//         StreamBuilder<SequenceState?>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: const Icon(Icons.replay_10),
//             onPressed: () {
//               rewind(player);
//             },
//           ),
//         ),
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: const CircularProgressIndicator(),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: player.play,
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 icon: const Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: player.pause,
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.replay),
//                 iconSize: 64.0,
//                 onPressed: () => player.seek(Duration.zero,
//                     index: player.effectiveIndices!.first),
//               );
//             }
//           },
//         ),
//         StreamBuilder<SequenceState?>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: const Icon(Icons.replay_10),
//             onPressed: () {
//               skipForward(player);
//             },
//           ),
//         ),
//         SkipButton(player: player),
//         StreamBuilder<double>(
//           stream: player.speedStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             onPressed: () {
//               showSliderDialog(
//                   context: context,
//                   title: "Adjust speed",
//                   divisions: 10,
//                   min: 0.5,
//                   max: 1.5,
//                   stream: player.speedStream,
//                   onChanged: player.setSpeed,
//                   value: player.speed);
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//
//   void skipPreviousBasedOnId(AudioPlayer audioPlayer) {
//     final sequence = audioPlayer.sequence;
//     if (sequence == null || audioPlayer.currentIndex == null) return;
//
//     final currentIndex = audioPlayer.currentIndex!;
//     final currentId = sequence[currentIndex].tag.extras!['id'];
//
//     debugPrint("currentIndex: $currentIndex  currentId: $currentId");
//     // Find the previous index that has a different id
//     int? previousIndex;
//     for (int i = currentIndex - 1; i >= 0; i--) {
//       if (sequence[i].tag.extras!['id'] != currentId) {
//         previousIndex = i;
//         if(sequence[i].tag.extras!['isExample'] == true){
//           previousIndex = i;
//         } else {
//           previousIndex = i;
//           previousIndex--;
//         }
//         if(!audioPlayer.playing){
//           audioPlayer.play();
//         }
//         break;
//       }
//     }
//
//     if (previousIndex != null) {
//       audioPlayer.seek(Duration.zero, index: previousIndex);
//     }
//   }
//
//
//   final Duration _skipDuration = Duration(seconds: 10);
//
//   void skipForward(AudioPlayer audioPlayer) {
//     final currentPosition = audioPlayer.position;
//     final newPosition = currentPosition + _skipDuration;
//     // Ensure newPosition does not exceed the duration of the audio
//     audioPlayer.seek(newPosition > (audioPlayer.duration ?? Duration.zero)
//         ? audioPlayer.duration
//         : newPosition);
//   }
//
//   void rewind(AudioPlayer audioPlayer) {
//     final currentPosition = audioPlayer.position;
//     final newPosition = currentPosition - _skipDuration;
//     // Ensure newPosition does not go below zero
//     audioPlayer.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
//   }
// }
// class SkipButton extends StatefulWidget {
//   const SkipButton({super.key, required this.player});
//   final AudioPlayer player;
//   @override
//   _SkipButtonState createState() => _SkipButtonState();
// }
//
// class _SkipButtonState extends State<SkipButton> with WidgetsBindingObserver {
//   bool _isAppInForeground = true;
//   final ValueNotifier<bool> isButtonDisabled = ValueNotifier<bool>(false);
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _isAppInForeground = true;
//     } else if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive ||
//         state == AppLifecycleState.detached) {
//       _isAppInForeground = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return StreamBuilder<SequenceState?>(
//     //   stream: widget.player.sequenceStateStream,
//     //   builder: (context, snapshot) => IconButton(
//     //     icon: const Icon(Icons.skip_next),
//     //     onPressed: () async {
//     //       if (widget.player.hasNext) {
//     //         skipForwardBasedOnId(widget.player);
//     //       } else {
//     //         if (_isAppInForeground) {
//     //           Duration cumulativeDuration = Duration.zero;
//     //           cumulativeDuration +=
//     //               AudioPlayerService().audioPlayer.duration ?? Duration.zero;
//     //           BlocProvider.of<TrainingBloc>(context).add(
//     //             TriggerChallengeDone(cumulativeDuration: cumulativeDuration),
//     //           );
//     //         } else {
//     //           widget.player.stop();
//     //           widget.player.seek(Duration.zero);
//     //         }
//     //       }
//     //     },
//     //   ),
//     // );
//     return ValueListenableBuilder<bool>(
//       valueListenable: isButtonDisabled,
//       builder: (context, isButtonDisabled, child) {
//         return StreamBuilder<SequenceState?>(
//           stream: widget.player.sequenceStateStream,
//           builder: (context, snapshot) {
//             return IconButton(
//               icon: const Icon(Icons.skip_next),
//               onPressed: handleButtonPress,
//               color: isButtonDisabled ? Colors.grey : null, // Optionally change color
//             );
//           },
//         );
//       },
//     );
//   }
//   void handleButtonPress() async {
//     if (isButtonDisabled.value) return; // Prevent button press if disabled
//
//
//     if (widget.player.hasNext) {
//       skipForwardBasedOnId(widget.player);
//     } else {
//       isButtonDisabled.value = true; // Disable button
//       if (_isAppInForeground) {
//         Duration cumulativeDuration = Duration.zero;
//         cumulativeDuration += AudioPlayerService().audioPlayer.duration ?? Duration.zero;
//         BlocProvider.of<TrainingBloc>(context).add(
//           TriggerChallengeDone(cumulativeDuration: cumulativeDuration),
//         );
//       } else {
//         widget.player.stop();
//         widget.player.seek(Duration.zero);
//       }
//     }
//   }
//
//   void skipForwardBasedOnId(AudioPlayer audioPlayer) {
//     final sequence = audioPlayer.sequence;
//     if (sequence == null || audioPlayer.currentIndex == null) return;
//
//     final currentIndex = audioPlayer.currentIndex!;
//     final currentId = sequence[currentIndex].tag.extras!['id'];
//
//     // Find the next index that has a different id
//     int? nextIndex;
//     for (int i = currentIndex + 1; i < sequence.length; i++) {
//       if (sequence[i].tag.extras!['id'] != currentId) {
//         nextIndex = i;
//         if(!audioPlayer.playing){
//           audioPlayer.play();
//         }
//         break;
//       }
//     }
//
//     if (nextIndex != null) {
//       audioPlayer.seek(Duration.zero, index: nextIndex);
//     }
//   }
// }
//
//
