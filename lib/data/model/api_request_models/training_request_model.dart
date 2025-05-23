class TrainingRequestModel{
  final double duration;
  final String level;
  final String type, voice, focus;

  TrainingRequestModel({required this.duration, required this.level,
    required this.type, required this.voice,
    required this.focus});
}