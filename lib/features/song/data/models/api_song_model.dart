// To parse this JSON data, do
//
//     final songListResopnseModel = songListResopnseModelFromJson(jsonString);

import 'dart:convert';

List<SongResopnseModel> songListResopnseModelFromJson(String str) =>
    List<SongResopnseModel>.from(
        json.decode(str).map((x) => SongResopnseModel.fromJson(x)));

String songListResopnseModelToJson(List<SongResopnseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SongResopnseModel {
  int id;
  String name;
  String audioUrl;
  String englishLyric;
  String vietnameseLyric;
  int displayOrder;
  WordTimestamp wordTimestamp;

  SongResopnseModel({
    required this.id,
    required this.name,
    required this.audioUrl,
    required this.englishLyric,
    required this.vietnameseLyric,
    required this.displayOrder,
    required this.wordTimestamp,
  });

  factory SongResopnseModel.fromJson(Map<String, dynamic> json) =>
      SongResopnseModel(
        id: json["id"],
        name: json["name"],
        audioUrl: json["audioUrl"],
        englishLyric: json["englishLyric"],
        vietnameseLyric: json["vietnameseLyric"],
        displayOrder: json["displayOrder"],
        wordTimestamp: WordTimestamp.fromJson(json["wordTimestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "audioUrl": audioUrl,
        "englishLyric": englishLyric,
        "vietnameseLyric": vietnameseLyric,
        "displayOrder": displayOrder,
        "wordTimestamp": wordTimestamp.toJson(),
      };
}

class WordTimestamp {
  String text;
  List<Word> words;

  WordTimestamp({
    required this.text,
    required this.words,
  });

  factory WordTimestamp.fromJson(Map<String, dynamic> json) => WordTimestamp(
        text: json["text"],
        words: List<Word>.from(json["words"].map((x) => Word.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "words": List<dynamic>.from(words.map((x) => x.toJson())),
      };
}

class Word {
  String word;
  double start;
  double end;

  Word({
    required this.word,
    required this.start,
    required this.end,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        word: json["word"],
        start: json["start"]?.toDouble(),
        end: json["end"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "start": start,
        "end": end,
      };
}
