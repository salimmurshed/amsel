import 'interval_data.dart';

class TrainingResponse {
  List<ListElement> list;
  int totalTrainingTime;

  TrainingResponse({
     required this.list,
    required this.totalTrainingTime
  });

  factory TrainingResponse.fromJson(Map<String, dynamic> json) => TrainingResponse(
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    totalTrainingTime: json["totalTrainingTime"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "totalTrainingTime": totalTrainingTime,
  };
}

class ListElement {
  int? id;
  String? beispielAudio;
  String? audiodatei;
  String? grafik;
  String? text;
  String? block;
  bool? sanft;
  bool? leicht;
  bool? mittel;
  bool? schwierig;
  int? artikulator;
  int? koerperarbeit;
  int? resonanz;
  int? luftgebrauch;
  int? gelaeufigkeit;
  int? vokalenausgleich;
  int? registerausgleich;
  int? aVokal;
  int? eVokal;
  int? iVokal;
  int? oVokal;
  int? uVokal;
  int? dauerAudio;
  int? dauerBeispiel;
  List<int>? intervall;
  List<String>? intervallBeschriftung;
  List<String>? intervallBeschriftungEnglisch;
  List<CombinedIntervalData>? intervalCombinedData;
  bool? isBreathInterval;
  String? beschreibung;
  String? beschreibungEnglish;
  bool? isExampleCompleted;
  bool? isChallengeCompleted;

  ListElement({
     this.id,
     this.beispielAudio,
     this.audiodatei,
     this.grafik,
     this.text,
     this.block,
    this.sanft,
     this.leicht,
     this.mittel,
     this.schwierig,
     this.artikulator,
     this.koerperarbeit,
     this.resonanz,
     this.luftgebrauch,
     this.gelaeufigkeit,
     this.vokalenausgleich,
     this.registerausgleich,
     this.aVokal,
     this.eVokal,
     this.iVokal,
     this.oVokal,
     this.uVokal,
     this.dauerAudio,
     this.dauerBeispiel,
    this.intervall,
    this.intervallBeschriftung,
    this.intervallBeschriftungEnglisch,
    this.intervalCombinedData,
    this.isBreathInterval,
    this.beschreibung,
    this.beschreibungEnglish,
    this.isExampleCompleted,
    this.isChallengeCompleted
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    beispielAudio: json["beispiel_audio"],
    audiodatei: json["audiodatei"],
    grafik: json["grafik"] ?? "",
    text: json["text"],
    block: json["block"],
    sanft: json["sanft"] ?? false,
    leicht: json["leicht"],
    mittel: json["mittel"],
    schwierig: json["schwierig"],
    artikulator: json["artikulator"],
    koerperarbeit: json["koerperarbeit"],
    resonanz: json["resonanz"],
    luftgebrauch: json["luftgebrauch"],
    gelaeufigkeit: json["gelaeufigkeit"],
    vokalenausgleich: json["vokalenausgleich"],
    registerausgleich: json["registerausgleich"],
    aVokal: json["a_vokal"],
    eVokal: json["e_vokal"],
    iVokal: json["i_vokal"],
    oVokal: json["o_vokal"],
    uVokal: json["u_vokal"],
    dauerAudio: json["dauer_audio"] ?? 0,
    dauerBeispiel: json["dauer_beispiel"] ?? 0,
    intervall: json["intervall"] == null ? [] : List<int>.from(json["intervall"].map((x) => x)),
    intervallBeschriftung: json["intervall_beschriftung"] == null ? [] : List<String>.from(json["intervall_beschriftung"].map((x) => x)),
    intervallBeschriftungEnglisch: json["intervall_beschriftung_englisch"] == null ? [] : List<String>.from(json["intervall_beschriftung_englisch"].map((x) => x)),
    intervalCombinedData: [],
    beschreibung: json["beschreibung"] ?? "",
    beschreibungEnglish: json["beschreibung_english"] ?? "",
    isExampleCompleted: json["isExampleCompleted"] ?? false,
    isChallengeCompleted: json["isChallengeCompleted"] ?? false,
    isBreathInterval: json["isBreathInterval"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "beispiel_audio": beispielAudio,
    "audiodatei": audiodatei,
    "grafik": grafik,
    "text": text,
    "block": block,
    "sanft": sanft,
    "leicht": leicht,
    "mittel": mittel,
    "schwierig": schwierig,
    "artikulator": artikulator,
    "koerperarbeit": koerperarbeit,
    "resonanz": resonanz,
    "luftgebrauch": luftgebrauch,
    "gelaeufigkeit": gelaeufigkeit,
    "vokalenausgleich": vokalenausgleich,
    "registerausgleich": registerausgleich,
    "a_vokal": aVokal,
    "e_vokal": eVokal,
    "i_vokal": iVokal,
    "o_vokal": oVokal,
    "u_vokal": uVokal,
    "dauer_audio": dauerAudio,
    "dauer_beispiel": dauerBeispiel,
    "intervall": List<dynamic>.from(intervall!.map((x) => x)),
    "intervall_beschriftung": List<dynamic>.from(intervallBeschriftung!.map((x) => x)),
    "intervall_beschriftung_englisch": List<dynamic>.from(intervallBeschriftungEnglisch!.map((x) => x)),
    "beschreibung": beschreibung,
    "beschreibung_english": beschreibungEnglish,
    "isExampleCompleted": isExampleCompleted,
    "isChallengeCompleted": isChallengeCompleted,
    "isBreathInterval": isBreathInterval,
  };
}