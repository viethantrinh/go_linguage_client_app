// To parse this JSON data, do
//
//     final examResopnseModel = examResopnseModelFromJson(jsonString);

import 'dart:convert';

ExamResopnseModel examResopnseModelFromJson(String str) =>
    ExamResopnseModel.fromJson(json.decode(str));

String examResopnseModelToJson(ExamResopnseModel data) =>
    json.encode(data.toJson());

class ExamResopnseModel {
  List<Exam> exams;
  List<FlashCard> flashCards;
  PreviousLearned previousLearned;

  ExamResopnseModel({
    required this.exams,
    required this.flashCards,
    required this.previousLearned,
  });

  factory ExamResopnseModel.fromJson(Map<String, dynamic> json) =>
      ExamResopnseModel(
        exams: List<Exam>.from(json["exams"].map((x) => Exam.fromJson(x))),
        flashCards: List<FlashCard>.from(
            json["flashCards"].map((x) => FlashCard.fromJson(x))),
        previousLearned: PreviousLearned.fromJson(json["previousLearned"]),
      );

  Map<String, dynamic> toJson() => {
        "exams": List<dynamic>.from(exams.map((x) => x.toJson())),
        "flashCards": List<dynamic>.from(flashCards.map((x) => x.toJson())),
        "previousLearned": previousLearned.toJson(),
      };
}

class Exam {
  int id;
  String instruction;
  int displayOrder;
  Data data;

  Exam({
    required this.id,
    required this.instruction,
    required this.displayOrder,
    required this.data,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
        id: json["id"],
        instruction: json["instruction"],
        displayOrder: json["displayOrder"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "instruction": instruction,
        "displayOrder": displayOrder,
        "data": data.toJson(),
      };
}

class Data {
  String sourceLanguage;
  String targetLanguage;
  String? questionType;
  QuestionElement? question;
  List<Option>? options;
  QuestionElement? sentence;
  List<Word>? words;

  Data({
    required this.sourceLanguage,
    required this.targetLanguage,
    this.questionType,
    this.question,
    this.options,
    this.sentence,
    this.words,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sourceLanguage: json["sourceLanguage"],
        targetLanguage: json["targetLanguage"],
        questionType: json["questionType"],
        question: json["question"] == null
            ? null
            : QuestionElement.fromJson(json["question"]),
        options: json["options"] == null
            ? []
            : List<Option>.from(
                json["options"]!.map((x) => Option.fromJson(x))),
        sentence: json["sentence"] == null
            ? null
            : QuestionElement.fromJson(json["sentence"]),
        words: json["words"] == null
            ? []
            : List<Word>.from(json["words"]!.map((x) => Word.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sourceLanguage": sourceLanguage,
        "targetLanguage": targetLanguage,
        "questionType": questionType,
        "question": question?.toJson(),
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "sentence": sentence?.toJson(),
        "words": words == null
            ? []
            : List<dynamic>.from(words!.map((x) => x.toJson())),
      };
}

class Option {
  OptionType optionType;
  bool isCorrect;
  String englishText;
  String vietnameseText;
  String? imageUrl;
  String audioUrl;

  Option({
    required this.optionType,
    required this.isCorrect,
    required this.englishText,
    required this.vietnameseText,
    this.imageUrl,
    required this.audioUrl,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionType: optionTypeValues.map[json["optionType"]]!,
        isCorrect: json["isCorrect"],
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        imageUrl: json["imageUrl"],
        audioUrl: json["audioUrl"],
      );

  Map<String, dynamic> toJson() => {
        "optionType": optionTypeValues.reverse[optionType],
        "isCorrect": isCorrect,
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "imageUrl": imageUrl,
        "audioUrl": audioUrl,
      };
}

enum OptionType { SENTENCE, WORD }

final optionTypeValues =
    EnumValues({"sentence": OptionType.SENTENCE, "word": OptionType.WORD});

class QuestionElement {
  String englishText;
  String vietnameseText;
  String? imageUrl;
  String audioUrl;
  QuestionElement? sentence;

  QuestionElement({
    required this.englishText,
    required this.vietnameseText,
    this.imageUrl,
    required this.audioUrl,
    this.sentence,
  });

  factory QuestionElement.fromJson(Map<String, dynamic> json) =>
      QuestionElement(
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        imageUrl: json["imageUrl"],
        audioUrl: json["audioUrl"],
        sentence: json["sentence"] == null
            ? null
            : QuestionElement.fromJson(json["sentence"]),
      );

  Map<String, dynamic> toJson() => {
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "imageUrl": imageUrl,
        "audioUrl": audioUrl,
        "sentence": sentence?.toJson(),
      };
}

class Word {
  String text;
  bool isDistractor;
  int correctPosition;

  Word({
    required this.text,
    required this.isDistractor,
    required this.correctPosition,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        text: json["text"],
        isDistractor: json["isDistractor"],
        correctPosition: json["correctPosition"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "isDistractor": isDistractor,
        "correctPosition": correctPosition,
      };
}

class FlashCard {
  int id;
  String name;
  int displayOrder;
  List<QuestionElement> data;

  FlashCard({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.data,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        id: json["id"],
        name: json["name"],
        displayOrder: json["displayOrder"],
        data: List<QuestionElement>.from(
            json["data"].map((x) => QuestionElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "displayOrder": displayOrder,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PreviousLearned {
  List<FlashCard> vocabularies;
  List<Dialogue> dialogues;

  PreviousLearned({
    required this.vocabularies,
    required this.dialogues,
  });

  factory PreviousLearned.fromJson(Map<String, dynamic> json) =>
      PreviousLearned(
        vocabularies: List<FlashCard>.from(
            json["vocabularies"].map((x) => FlashCard.fromJson(x))),
        dialogues: List<Dialogue>.from(
            json["dialogues"].map((x) => Dialogue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "vocabularies": List<dynamic>.from(vocabularies.map((x) => x.toJson())),
        "dialogues": List<dynamic>.from(dialogues.map((x) => x.toJson())),
      };
}

class Dialogue {
  int id;
  String name;
  int displayOrder;
  List<dynamic> data;

  Dialogue({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.data,
  });

  factory Dialogue.fromJson(Map<String, dynamic> json) => Dialogue(
        id: json["id"],
        name: json["name"],
        displayOrder: json["displayOrder"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "displayOrder": displayOrder,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DialogueDatum {
  String context;
  List<DialogueExerciseLine> dialogueExerciseLines;

  DialogueDatum({
    required this.context,
    required this.dialogueExerciseLines,
  });

  factory DialogueDatum.fromJson(Map<String, dynamic> json) => DialogueDatum(
        context: json["context"],
        dialogueExerciseLines: List<DialogueExerciseLine>.from(
            json["dialogueExerciseLines"]
                .map((x) => DialogueExerciseLine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "context": context,
        "dialogueExerciseLines":
            List<dynamic>.from(dialogueExerciseLines.map((x) => x.toJson())),
      };
}

class DialogueExerciseLine {
  bool isChangeSpeaker;
  String englishText;
  String vietnameseText;
  String audioUrl;
  int displayOrder;
  dynamic blankWord;

  DialogueExerciseLine({
    required this.isChangeSpeaker,
    required this.englishText,
    required this.vietnameseText,
    required this.audioUrl,
    required this.displayOrder,
    required this.blankWord,
  });

  factory DialogueExerciseLine.fromJson(Map<String, dynamic> json) =>
      DialogueExerciseLine(
        isChangeSpeaker: json["isChangeSpeaker"],
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        audioUrl: json["audioUrl"],
        displayOrder: json["displayOrder"],
        blankWord: json["blankWord"],
      );

  Map<String, dynamic> toJson() => {
        "isChangeSpeaker": isChangeSpeaker,
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "audioUrl": audioUrl,
        "displayOrder": displayOrder,
        "blankWord": blankWord,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
