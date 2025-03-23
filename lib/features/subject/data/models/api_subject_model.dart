// // // // To parse this JSON data, do
// // // //
// // // //     final lessonModel = lessonModelFromJson(jsonString);

// // // import 'dart:convert';

// // // class LessonModelResponse {
// // //   final List<LessonModel> lessons;

// // //   LessonModelResponse({required this.lessons});

// // //   factory LessonModelResponse.fromJson(Map<String, dynamic> json) =>
// // //       LessonModelResponse(
// // //         lessons: List<LessonModel>.from(
// // //             json["lessons"].map((x) => LessonModel.fromJson(x))),
// // //       );
// // // }

// // // List<LessonModel> lessonModelFromJson(String str) => List<LessonModel>.from(
// // //     json.decode(str).map((x) => LessonModel.fromJson(x)));

// // // String lessonModelToJson(List<LessonModel> data) =>
// // //     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// // // class LessonModel {
// // //   int id;
// // //   String name;
// // //   int totalUserXpPoints;
// // //   int lessonType;
// // //   int displayOrder;
// // //   List<Exercise> exercises;

// // //   LessonModel({
// // //     required this.id,
// // //     required this.name,
// // //     required this.totalUserXpPoints,
// // //     required this.lessonType,
// // //     required this.displayOrder,
// // //     required this.exercises,
// // //   });

// // //   factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
// // //         id: json["id"],
// // //         name: json["name"],
// // //         totalUserXpPoints: json["totalUserXPPoints"],
// // //         lessonType: json["lessonType"],
// // //         displayOrder: json["displayOrder"],
// // //         exercises: List<Exercise>.from(
// // //             json["exercises"].map((x) => Exercise.fromJson(x))),
// // //       );

// // //   Map<String, dynamic> toJson() => {
// // //         "id": id,
// // //         "name": name,
// // //         "totalUserXPPoints": totalUserXpPoints,
// // //         "lessonType": lessonType,
// // //         "displayOrder": displayOrder,
// // //         "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
// // //       };
// // // }

// // // class Exercise {
// // //   int id;
// // //   String instruction;
// // //   int displayOrder;
// // //   dynamic data;

// // //   Exercise({
// // //     required this.id,
// // //     required this.instruction,
// // //     required this.displayOrder,
// // //     required this.data,
// // //   });

// // //   factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
// // //         id: json["id"],
// // //         instruction: json["instruction"],
// // //         displayOrder: json["displayOrder"],
// // //         data: json["data"],
// // //       );

// // //   Map<String, dynamic> toJson() => {
// // //         "id": id,
// // //         "instruction": instruction,
// // //         "displayOrder": displayOrder,
// // //         "data": data,
// // //       };
// // // }

// // // class Datum {
// // //   int? id;
// // //   String englishText;
// // //   String vietnameseText;
// // //   String? imageUrl;
// // //   String audioUrl;

// // //   Datum({
// // //     this.id,
// // //     required this.englishText,
// // //     required this.vietnameseText,
// // //     this.imageUrl,
// // //     required this.audioUrl,
// // //   });

// // //   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
// // //         id: json["id"],
// // //         englishText: json["englishText"],
// // //         vietnameseText: json["vietnameseText"],
// // //         imageUrl: json["imageUrl"],
// // //         audioUrl: json["audioUrl"],
// // //       );

// // //   Map<String, dynamic> toJson() => {
// // //         "id": id,
// // //         "englishText": englishText,
// // //         "vietnameseText": vietnameseText,
// // //         "imageUrl": imageUrl,
// // //         "audioUrl": audioUrl,
// // //       };
// // // }

// // // class DataClass {
// // //   String? englishText;
// // //   String? vietnameseText;
// // //   String? imageUrl;
// // //   String? audioUrl;
// // //   Datum? sentence;
// // //   String? sourceLanguage;
// // //   String? targetLanguage;
// // //   TionType? questionType;
// // //   Datum? question;
// // //   List<Option>? options;
// // //   List<Word>? words;
// // //   String? context;
// // //   List<DialogueExerciseLine>? dialogueExerciseLines;

// // //   DataClass({
// // //     this.englishText,
// // //     this.vietnameseText,
// // //     this.imageUrl,
// // //     this.audioUrl,
// // //     this.sentence,
// // //     this.sourceLanguage,
// // //     this.targetLanguage,
// // //     this.questionType,
// // //     this.question,
// // //     this.options,
// // //     this.words,
// // //     this.context,
// // //     this.dialogueExerciseLines,
// // //   });

// // //   factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
// // //         englishText: json["englishText"],
// // //         vietnameseText: json["vietnameseText"],
// // //         imageUrl: json["imageUrl"],
// // //         audioUrl: json["audioUrl"],
// // //         sentence:
// // //             json["sentence"] == null ? null : Datum.fromJson(json["sentence"]),
// // //         sourceLanguage: json["sourceLanguage"],
// // //         targetLanguage: json["targetLanguage"],
// // //         questionType: tionTypeValues.map[json["questionType"]]!,
// // //         question:
// // //             json["question"] == null ? null : Datum.fromJson(json["question"]),
// // //         options: json["options"] == null
// // //             ? []
// // //             : List<Option>.from(
// // //                 json["options"]!.map((x) => Option.fromJson(x))),
// // //         words: json["words"] == null
// // //             ? []
// // //             : List<Word>.from(json["words"]!.map((x) => Word.fromJson(x))),
// // //         context: json["context"],
// // //         dialogueExerciseLines: json["dialogueExerciseLines"] == null
// // //             ? []
// // //             : List<DialogueExerciseLine>.from(json["dialogueExerciseLines"]!
// // //                 .map((x) => DialogueExerciseLine.fromJson(x))),
// // //       );

// // //   Map<String, dynamic> toJson() => {
// // //         "englishText": englishText,
// // //         "vietnameseText": vietnameseText,
// // //         "imageUrl": imageUrl,
// // //         "audioUrl": audioUrl,
// // //         "sentence": sentence?.toJson(),
// // //         "sourceLanguage": sourceLanguage,
// // //         "targetLanguage": targetLanguage,
// // //         "questionType": tionTypeValues.reverse[questionType],
// // //         "question": question?.toJson(),
// // //         "options": options == null
// // //             ? []
// // //             : List<dynamic>.from(options!.map((x) => x.toJson())),
// // //         "words": words == null
// // //             ? []
// // //             : List<dynamic>.from(words!.map((x) => x.toJson())),
// // //         "context": context,
// // //         "dialogueExerciseLines": dialogueExerciseLines == null
// // //             ? []
// // //             : List<dynamic>.from(dialogueExerciseLines!.map((x) => x.toJson())),
// // //       };
// // // }

// // // class DialogueExerciseLine {
// // //   Speaker speaker;
// // //   String englishText;
// // //   String vietnameseText;
// // //   String audioUrl;
// // //   int displayOrder;
// // //   bool hasBlank;
// // //   String? blankWord;

// // //   DialogueExerciseLine({
// // //     required this.speaker,
// // //     required this.englishText,
// // //     required this.vietnameseText,
// // //     required this.audioUrl,
// // //     required this.displayOrder,
// // //     required this.hasBlank,
// // //     required this.blankWord,
// // //   });

// // //   factory DialogueExerciseLine.fromJson(Map<String, dynamic> json) =>
// // //       DialogueExerciseLine(
// // //         speaker: speakerValues.map[json["speaker"]]!,
// // //         englishText: json["englishText"],
// // //         vietnameseText: json["vietnameseText"],
// // //         audioUrl: json["audioUrl"],
// // //         displayOrder: json["displayOrder"],
// // //         hasBlank: json["hasBlank"],
// // //         blankWord: json["blankWord"],
// // //       );

// // //   Map<String, dynamic> toJson() => {
// // //         "speaker": speakerValues.reverse[speaker],
// // //         "englishText": englishText,
// // //         "vietnameseText": vietnameseText,
// // //         "audioUrl": audioUrl,
// // //         "displayOrder": displayOrder,
// // //         "hasBlank": hasBlank,
// // //         "blankWord": blankWord,
// // //       };
// // // }

// // // enum Speaker { A, B }

// // // final speakerValues = EnumValues({"A": Speaker.A, "B": Speaker.B});

// // // class Option {
// // //   TionType optionType;
// // //   bool isCorrect;
// // //   String englishText;
// // //   String vietnameseText;
// // //   String? imageUrl;
// // //   String audioUrl;

// // //   Option({
// // //     required this.optionType,
// // //     required this.isCorrect,
// // //     required this.englishText,
// // //     required this.vietnameseText,
// // //     this.imageUrl,
// // //     required this.audioUrl,
// // //   });

// // //   factory Option.fromJson(Map<String, dynamic> json) => Option(
// // //         optionType: tionTypeValues.map[json["optionType"]]!,
// // //         isCorrect: json["isCorrect"],
// // //         englishText: json["englishText"],
// // //         vietnameseText: json["vietnameseText"],
// // //         imageUrl: json["imageUrl"],
// // //         audioUrl: json["audioUrl"],
// // //       );

// // //   Map<String, dynamic> toJson() => {
// // //         "optionType": tionTypeValues.reverse[optionType],
// // //         "isCorrect": isCorrect,
// // //         "englishText": englishText,
// // //         "vietnameseText": vietnameseText,
// // //         "imageUrl": imageUrl,
// // //         "audioUrl": audioUrl,
// // //       };
// // // }

// // // enum TionType { SENTENCE, WORD }

// // // final tionTypeValues =
// // //     EnumValues({"sentence": TionType.SENTENCE, "word": TionType.WORD});

// // // class Word {
// // //   String text;
// // //   bool isDistractor;
// // //   int correctPosition;

// // //   Word({
// // //     required this.text,
// // //     required this.isDistractor,
// // //     required this.correctPosition,
// // //   });

// // //   factory Word.fromJson(Map<String, dynamic> json) => Word(
// // //         text: json["text"],
// // //         isDistractor: json["isDistractor"],
// // //         correctPosition: json["correctPosition"],
// // //       );

// // //   Map<String, dynamic> toJson() => {
// // //         "text": text,
// // //         "isDistractor": isDistractor,
// // //         "correctPosition": correctPosition,
// // //       };
// // // }

// // // class EnumValues<T> {
// // //   Map<String, T> map;
// // //   late Map<T, String> reverseMap;

// // //   EnumValues(this.map);

// // //   Map<T, String> get reverse {
// // //     reverseMap = map.map((k, v) => MapEntry(v, k));
// // //     return reverseMap;
// // //   }
// // // }
// // // To parse this JSON data, do
// // //
// // //     final lessonModel = lessonModelFromJson(jsonString);

// // import 'dart:convert';

// // List<LessonModel> lessonModelFromJson(String str) => List<LessonModel>.from(json.decode(str).map((x) => LessonModel.fromJson(x)));

// // String lessonModelToJson(List<LessonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// // class LessonModel {
// //     int id;
// //     String name;
// //     int totalUserXpPoints;
// //     int lessonType;
// //     int displayOrder;
// //     List<Exercise> exercises;

// //     LessonModel({
// //         required this.id,
// //         required this.name,
// //         required this.totalUserXpPoints,
// //         required this.lessonType,
// //         required this.displayOrder,
// //         required this.exercises,
// //     });

// //     factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
// //         id: json["id"],
// //         name: json["name"],
// //         totalUserXpPoints: json["totalUserXPPoints"],
// //         lessonType: json["lessonType"],
// //         displayOrder: json["displayOrder"],
// //         exercises: List<Exercise>.from(json["exercises"].map((x) => Exercise.fromJson(x))),
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "id": id,
// //         "name": name,
// //         "totalUserXPPoints": totalUserXpPoints,
// //         "lessonType": lessonType,
// //         "displayOrder": displayOrder,
// //         "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
// //     };
// // }

// // class Exercise {
// //     int? id;
// //     String? instruction;
// //     int? displayOrder;
// //     dynamic data;
// //     String? englishText;
// //     String? vietnameseText;
// //     String? audioUrl;

// //     Exercise({
// //         this.id,
// //         this.instruction,
// //         this.displayOrder,
// //         this.data,
// //         this.englishText,
// //         this.vietnameseText,
// //         this.audioUrl,
// //     });

// //     factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
// //         id: json["id"],
// //         instruction: json["instruction"],
// //         displayOrder: json["displayOrder"],
// //         data: json["data"],
// //         englishText: json["englishText"],
// //         vietnameseText: json["vietnameseText"],
// //         audioUrl: json["audioUrl"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "id": id,
// //         "instruction": instruction,
// //         "displayOrder": displayOrder,
// //         "data": data,
// //         "englishText": englishText,
// //         "vietnameseText": vietnameseText,
// //         "audioUrl": audioUrl,
// //     };
// // }

// // class Datum {
// //     int? id;
// //     String englishText;
// //     String vietnameseText;
// //     String? imageUrl;
// //     String audioUrl;

// //     Datum({
// //         this.id,
// //         required this.englishText,
// //         required this.vietnameseText,
// //         this.imageUrl,
// //         required this.audioUrl,
// //     });

// //     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
// //         id: json["id"],
// //         englishText: json["englishText"],
// //         vietnameseText: json["vietnameseText"],
// //         imageUrl: json["imageUrl"],
// //         audioUrl: json["audioUrl"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "id": id,
// //         "englishText": englishText,
// //         "vietnameseText": vietnameseText,
// //         "imageUrl": imageUrl,
// //         "audioUrl": audioUrl,
// //     };
// // }

// // class DataClass {
// //     String? englishText;
// //     String? vietnameseText;
// //     String? imageUrl;
// //     String? audioUrl;
// //     Datum? sentence;
// //     Language? sourceLanguage;
// //     Language? targetLanguage;
// //     TionType? questionType;
// //     Datum? question;
// //     List<Option>? options;
// //     List<Word>? words;
// //     String? context;
// //     List<DialogueExerciseLine>? dialogueExerciseLines;

// //     DataClass({
// //         this.englishText,
// //         this.vietnameseText,
// //         this.imageUrl,
// //         this.audioUrl,
// //         this.sentence,
// //         this.sourceLanguage,
// //         this.targetLanguage,
// //         this.questionType,
// //         this.question,
// //         this.options,
// //         this.words,
// //         this.context,
// //         this.dialogueExerciseLines,
// //     });

// //     factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
// //         englishText: json["englishText"],
// //         vietnameseText: json["vietnameseText"],
// //         imageUrl: json["imageUrl"],
// //         audioUrl: json["audioUrl"],
// //         sentence: json["sentence"] == null ? null : Datum.fromJson(json["sentence"]),
// //         sourceLanguage: languageValues.map[json["sourceLanguage"]]!,
// //         targetLanguage: languageValues.map[json["targetLanguage"]]!,
// //         questionType: tionTypeValues.map[json["questionType"]]!,
// //         question: json["question"] == null ? null : Datum.fromJson(json["question"]),
// //         options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
// //         words: json["words"] == null ? [] : List<Word>.from(json["words"]!.map((x) => Word.fromJson(x))),
// //         context: json["context"],
// //         dialogueExerciseLines: json["dialogueExerciseLines"] == null ? [] : List<DialogueExerciseLine>.from(json["dialogueExerciseLines"]!.map((x) => DialogueExerciseLine.fromJson(x))),
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "englishText": englishText,
// //         "vietnameseText": vietnameseText,
// //         "imageUrl": imageUrl,
// //         "audioUrl": audioUrl,
// //         "sentence": sentence?.toJson(),
// //         "sourceLanguage": languageValues.reverse[sourceLanguage],
// //         "targetLanguage": languageValues.reverse[targetLanguage],
// //         "questionType": tionTypeValues.reverse[questionType],
// //         "question": question?.toJson(),
// //         "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
// //         "words": words == null ? [] : List<dynamic>.from(words!.map((x) => x.toJson())),
// //         "context": context,
// //         "dialogueExerciseLines": dialogueExerciseLines == null ? [] : List<dynamic>.from(dialogueExerciseLines!.map((x) => x.toJson())),
// //     };
// // }

// // class DialogueExerciseLine {
// //     Speaker speaker;
// //     String englishText;
// //     String vietnameseText;
// //     String audioUrl;
// //     int displayOrder;
// //     bool hasBlank;
// //     String? blankWord;

// //     DialogueExerciseLine({
// //         required this.speaker,
// //         required this.englishText,
// //         required this.vietnameseText,
// //         required this.audioUrl,
// //         required this.displayOrder,
// //         required this.hasBlank,
// //         required this.blankWord,
// //     });

// //     factory DialogueExerciseLine.fromJson(Map<String, dynamic> json) => DialogueExerciseLine(
// //         speaker: speakerValues.map[json["speaker"]]!,
// //         englishText: json["englishText"],
// //         vietnameseText: json["vietnameseText"],
// //         audioUrl: json["audioUrl"],
// //         displayOrder: json["displayOrder"],
// //         hasBlank: json["hasBlank"],
// //         blankWord: json["blankWord"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "speaker": speakerValues.reverse[speaker],
// //         "englishText": englishText,
// //         "vietnameseText": vietnameseText,
// //         "audioUrl": audioUrl,
// //         "displayOrder": displayOrder,
// //         "hasBlank": hasBlank,
// //         "blankWord": blankWord,
// //     };
// // }

// // enum Speaker {
// //     A,
// //     B
// // }

// // final speakerValues = EnumValues({
// //     "A": Speaker.A,
// //     "B": Speaker.B
// // });

// // class Option {
// //     TionType optionType;
// //     bool isCorrect;
// //     String englishText;
// //     String vietnameseText;
// //     String? imageUrl;
// //     String audioUrl;

// //     Option({
// //         required this.optionType,
// //         required this.isCorrect,
// //         required this.englishText,
// //         required this.vietnameseText,
// //         this.imageUrl,
// //         required this.audioUrl,
// //     });

// //     factory Option.fromJson(Map<String, dynamic> json) => Option(
// //         optionType: tionTypeValues.map[json["optionType"]]!,
// //         isCorrect: json["isCorrect"],
// //         englishText: json["englishText"],
// //         vietnameseText: json["vietnameseText"],
// //         imageUrl: json["imageUrl"],
// //         audioUrl: json["audioUrl"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "optionType": tionTypeValues.reverse[optionType],
// //         "isCorrect": isCorrect,
// //         "englishText": englishText,
// //         "vietnameseText": vietnameseText,
// //         "imageUrl": imageUrl,
// //         "audioUrl": audioUrl,
// //     };
// // }

// // enum TionType {
// //     SENTENCE,
// //     WORD
// // }

// // final tionTypeValues = EnumValues({
// //     "sentence": TionType.SENTENCE,
// //     "word": TionType.WORD
// // });

// // enum Language {
// //     ENGLISH,
// //     VIETNAMESE
// // }

// // final languageValues = EnumValues({
// //     "english": Language.ENGLISH,
// //     "vietnamese": Language.VIETNAMESE
// // });

// // class Word {
// //     String text;
// //     bool isDistractor;
// //     int correctPosition;

// //     Word({
// //         required this.text,
// //         required this.isDistractor,
// //         required this.correctPosition,
// //     });

// //     factory Word.fromJson(Map<String, dynamic> json) => Word(
// //         text: json["text"],
// //         isDistractor: json["isDistractor"],
// //         correctPosition: json["correctPosition"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "text": text,
// //         "isDistractor": isDistractor,
// //         "correctPosition": correctPosition,
// //     };
// // }

// // class EnumValues<T> {
// //     Map<String, T> map;
// //     late Map<T, String> reverseMap;

// //     EnumValues(this.map);

// //     Map<T, String> get reverse {
// //             reverseMap = map.map((k, v) => MapEntry(v, k));
// //             return reverseMap;
// //     }
// // }
// // To parse this JSON data, do
// //
// //     final lessonModel = lessonModelFromJson(jsonString);

// import 'dart:convert';

// List<LessonModel> lessonModelFromJson(String str) => List<LessonModel>.from(json.decode(str).map((x) => LessonModel.fromJson(x)));

// String lessonModelToJson(List<LessonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class LessonModel {
//     int id;
//     String name;
//     int totalUserXpPoints;
//     int lessonType;
//     int displayOrder;
//     List<Exercise> exercises;

//     LessonModel({
//         required this.id,
//         required this.name,
//         required this.totalUserXpPoints,
//         required this.lessonType,
//         required this.displayOrder,
//         required this.exercises,
//     });

//     factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
//         id: json["id"],
//         name: json["name"],
//         totalUserXpPoints: json["totalUserXPPoints"],
//         lessonType: json["lessonType"],
//         displayOrder: json["displayOrder"],
//         exercises: List<Exercise>.from(json["exercises"].map((x) => Exercise.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "totalUserXPPoints": totalUserXpPoints,
//         "lessonType": lessonType,
//         "displayOrder": displayOrder,
//         "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
//     };
// }

// class Exercise {
//     int? id;
//     String? instruction;
//     int? displayOrder;
//     dynamic data;
//     String? englishText;
//     String? vietnameseText;
//     String? audioUrl;

//     Exercise({
//         this.id,
//         this.instruction,
//         this.displayOrder,
//         this.data,
//         this.englishText,
//         this.vietnameseText,
//         this.audioUrl,
//     });

//     factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
//         id: json["id"],
//         instruction: json["instruction"],
//         displayOrder: json["displayOrder"],
//         data: json["data"],
//         englishText: json["englishText"],
//         vietnameseText: json["vietnameseText"],
//         audioUrl: json["audioUrl"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "instruction": instruction,
//         "displayOrder": displayOrder,
//         "data": data,
//         "englishText": englishText,
//         "vietnameseText": vietnameseText,
//         "audioUrl": audioUrl,
//     };
// }

// class Datum {
//     int? id;
//     String englishText;
//     String vietnameseText;
//     String? imageUrl;
//     String audioUrl;

//     Datum({
//         this.id,
//         required this.englishText,
//         required this.vietnameseText,
//         this.imageUrl,
//         required this.audioUrl,
//     });

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         englishText: json["englishText"],
//         vietnameseText: json["vietnameseText"],
//         imageUrl: json["imageUrl"],
//         audioUrl: json["audioUrl"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "englishText": englishText,
//         "vietnameseText": vietnameseText,
//         "imageUrl": imageUrl,
//         "audioUrl": audioUrl,
//     };
// }

// class DataClass {
//     String? englishText;
//     String? vietnameseText;
//     String? imageUrl;
//     String? audioUrl;
//     Datum? sentence;
//     Language? sourceLanguage;
//     Language? targetLanguage;
//     TionType? questionType;
//     Datum? question;
//     List<Option>? options;
//     List<Word>? words;
//     String? context;
//     List<DialogueExerciseLine>? dialogueExerciseLines;

//     DataClass({
//         this.englishText,
//         this.vietnameseText,
//         this.imageUrl,
//         this.audioUrl,
//         this.sentence,
//         this.sourceLanguage,
//         this.targetLanguage,
//         this.questionType,
//         this.question,
//         this.options,
//         this.words,
//         this.context,
//         this.dialogueExerciseLines,
//     });

//     factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
//         englishText: json["englishText"],
//         vietnameseText: json["vietnameseText"],
//         imageUrl: json["imageUrl"],
//         audioUrl: json["audioUrl"],
//         sentence: json["sentence"] == null ? null : Datum.fromJson(json["sentence"]),
//         sourceLanguage: languageValues.map[json["sourceLanguage"]]!,
//         targetLanguage: languageValues.map[json["targetLanguage"]]!,
//         questionType: tionTypeValues.map[json["questionType"]]!,
//         question: json["question"] == null ? null : Datum.fromJson(json["question"]),
//         options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
//         words: json["words"] == null ? [] : List<Word>.from(json["words"]!.map((x) => Word.fromJson(x))),
//         context: json["context"],
//         dialogueExerciseLines: json["dialogueExerciseLines"] == null ? [] : List<DialogueExerciseLine>.from(json["dialogueExerciseLines"]!.map((x) => DialogueExerciseLine.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "englishText": englishText,
//         "vietnameseText": vietnameseText,
//         "imageUrl": imageUrl,
//         "audioUrl": audioUrl,
//         "sentence": sentence?.toJson(),
//         "sourceLanguage": languageValues.reverse[sourceLanguage],
//         "targetLanguage": languageValues.reverse[targetLanguage],
//         "questionType": tionTypeValues.reverse[questionType],
//         "question": question?.toJson(),
//         "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
//         "words": words == null ? [] : List<dynamic>.from(words!.map((x) => x.toJson())),
//         "context": context,
//         "dialogueExerciseLines": dialogueExerciseLines == null ? [] : List<dynamic>.from(dialogueExerciseLines!.map((x) => x.toJson())),
//     };
// }

// class DialogueExerciseLine {
//     Speaker speaker;
//     String englishText;
//     String vietnameseText;
//     String audioUrl;
//     int displayOrder;
//     bool hasBlank;
//     String? blankWord;

//     DialogueExerciseLine({
//         required this.speaker,
//         required this.englishText,
//         required this.vietnameseText,
//         required this.audioUrl,
//         required this.displayOrder,
//         required this.hasBlank,
//         required this.blankWord,
//     });

//     factory DialogueExerciseLine.fromJson(Map<String, dynamic> json) => DialogueExerciseLine(
//         speaker: speakerValues.map[json["speaker"]]!,
//         englishText: json["englishText"],
//         vietnameseText: json["vietnameseText"],
//         audioUrl: json["audioUrl"],
//         displayOrder: json["displayOrder"],
//         hasBlank: json["hasBlank"],
//         blankWord: json["blankWord"],
//     );

//     Map<String, dynamic> toJson() => {
//         "speaker": speakerValues.reverse[speaker],
//         "englishText": englishText,
//         "vietnameseText": vietnameseText,
//         "audioUrl": audioUrl,
//         "displayOrder": displayOrder,
//         "hasBlank": hasBlank,
//         "blankWord": blankWord,
//     };
// }

// enum Speaker {
//     A,
//     B
// }

// final speakerValues = EnumValues({
//     "A": Speaker.A,
//     "B": Speaker.B
// });

// class Option {
//     TionType optionType;
//     bool isCorrect;
//     String englishText;
//     String vietnameseText;
//     String? imageUrl;
//     String audioUrl;

//     Option({
//         required this.optionType,
//         required this.isCorrect,
//         required this.englishText,
//         required this.vietnameseText,
//         this.imageUrl,
//         required this.audioUrl,
//     });

//     factory Option.fromJson(Map<String, dynamic> json) => Option(
//         optionType: tionTypeValues.map[json["optionType"]]!,
//         isCorrect: json["isCorrect"],
//         englishText: json["englishText"],
//         vietnameseText: json["vietnameseText"],
//         imageUrl: json["imageUrl"],
//         audioUrl: json["audioUrl"],
//     );

//     Map<String, dynamic> toJson() => {
//         "optionType": tionTypeValues.reverse[optionType],
//         "isCorrect": isCorrect,
//         "englishText": englishText,
//         "vietnameseText": vietnameseText,
//         "imageUrl": imageUrl,
//         "audioUrl": audioUrl,
//     };
// }

// enum TionType {
//     SENTENCE,
//     WORD
// }

// final tionTypeValues = EnumValues({
//     "sentence": TionType.SENTENCE,
//     "word": TionType.WORD
// });

// enum Language {
//     ENGLISH,
//     VIETNAMESE
// }

// final languageValues = EnumValues({
//     "english": Language.ENGLISH,
//     "vietnamese": Language.VIETNAMESE
// });

// class Word {
//     String text;
//     bool isDistractor;
//     int correctPosition;

//     Word({
//         required this.text,
//         required this.isDistractor,
//         required this.correctPosition,
//     });

//     factory Word.fromJson(Map<String, dynamic> json) => Word(
//         text: json["text"],
//         isDistractor: json["isDistractor"],
//         correctPosition: json["correctPosition"],
//     );

//     Map<String, dynamic> toJson() => {
//         "text": text,
//         "isDistractor": isDistractor,
//         "correctPosition": correctPosition,
//     };
// }

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//             reverseMap = map.map((k, v) => MapEntry(v, k));
//             return reverseMap;
//     }
// }
// To parse this JSON data, do
//
//     final lessonModel = lessonModelFromJson(jsonString);

import 'dart:convert';

List<LessonModel> lessonModelFromJson(String str) => List<LessonModel>.from(json.decode(str).map((x) => LessonModel.fromJson(x)));

String lessonModelToJson(List<LessonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LessonModel {
    int id;
    String name;
    int totalUserXpPoints;
    int lessonType;
    int displayOrder;
    List<Exercise> exercises;

    LessonModel({
        required this.id,
        required this.name,
        required this.totalUserXpPoints,
        required this.lessonType,
        required this.displayOrder,
        required this.exercises,
    });

    factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json["id"],
        name: json["name"],
        totalUserXpPoints: json["totalUserXPPoints"],
        lessonType: json["lessonType"],
        displayOrder: json["displayOrder"],
        exercises: List<Exercise>.from(json["exercises"].map((x) => Exercise.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "totalUserXPPoints": totalUserXpPoints,
        "lessonType": lessonType,
        "displayOrder": displayOrder,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
    };
}

class Exercise {
    int? id;
    String? instruction;
    int? displayOrder;
    dynamic data;
    String? englishText;
    String? vietnameseText;
    String? audioUrl;

    Exercise({
        this.id,
        this.instruction,
        this.displayOrder,
        this.data,
        this.englishText,
        this.vietnameseText,
        this.audioUrl,
    });

    factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["id"],
        instruction: json["instruction"],
        displayOrder: json["displayOrder"],
        data: json["data"],
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        audioUrl: json["audioUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "instruction": instruction,
        "displayOrder": displayOrder,
        "data": data,
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "audioUrl": audioUrl,
    };
}

class Datum {
    int? id;
    String englishText;
    String vietnameseText;
    String? imageUrl;
    String audioUrl;

    Datum({
        this.id,
        required this.englishText,
        required this.vietnameseText,
        this.imageUrl,
        required this.audioUrl,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        imageUrl: json["imageUrl"],
        audioUrl: json["audioUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "imageUrl": imageUrl,
        "audioUrl": audioUrl,
    };
}

class DataClass {
    String? englishText;
    String? vietnameseText;
    String? imageUrl;
    String? audioUrl;
    Datum? sentence;
    Language? sourceLanguage;
    Language? targetLanguage;
    TionType? questionType;
    Datum? question;
    List<Option>? options;
    List<Word>? words;
    String? context;
    List<DialogueExerciseLine>? dialogueExerciseLines;

    DataClass({
        this.englishText,
        this.vietnameseText,
        this.imageUrl,
        this.audioUrl,
        this.sentence,
        this.sourceLanguage,
        this.targetLanguage,
        this.questionType,
        this.question,
        this.options,
        this.words,
        this.context,
        this.dialogueExerciseLines,
    });

    factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        imageUrl: json["imageUrl"],
        audioUrl: json["audioUrl"],
        sentence: json["sentence"] == null ? null : Datum.fromJson(json["sentence"]),
        sourceLanguage: languageValues.map[json["sourceLanguage"]]!,
        targetLanguage: languageValues.map[json["targetLanguage"]]!,
        questionType: tionTypeValues.map[json["questionType"]]!,
        question: json["question"] == null ? null : Datum.fromJson(json["question"]),
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
        words: json["words"] == null ? [] : List<Word>.from(json["words"]!.map((x) => Word.fromJson(x))),
        context: json["context"],
        dialogueExerciseLines: json["dialogueExerciseLines"] == null ? [] : List<DialogueExerciseLine>.from(json["dialogueExerciseLines"]!.map((x) => DialogueExerciseLine.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "imageUrl": imageUrl,
        "audioUrl": audioUrl,
        "sentence": sentence?.toJson(),
        "sourceLanguage": languageValues.reverse[sourceLanguage],
        "targetLanguage": languageValues.reverse[targetLanguage],
        "questionType": tionTypeValues.reverse[questionType],
        "question": question?.toJson(),
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
        "words": words == null ? [] : List<dynamic>.from(words!.map((x) => x.toJson())),
        "context": context,
        "dialogueExerciseLines": dialogueExerciseLines == null ? [] : List<dynamic>.from(dialogueExerciseLines!.map((x) => x.toJson())),
    };
}

class DialogueExerciseLine {
    bool isChangeSpeaker;
    String englishText;
    String vietnameseText;
    String audioUrl;
    int displayOrder;
    String? blankWord;

    DialogueExerciseLine({
        required this.isChangeSpeaker,
        required this.englishText,
        required this.vietnameseText,
        required this.audioUrl,
        required this.displayOrder,
        required this.blankWord,
    });

    factory DialogueExerciseLine.fromJson(Map<String, dynamic> json) => DialogueExerciseLine(
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

class Option {
    TionType optionType;
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
        optionType: tionTypeValues.map[json["optionType"]]!,
        isCorrect: json["isCorrect"],
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        imageUrl: json["imageUrl"],
        audioUrl: json["audioUrl"],
    );

    Map<String, dynamic> toJson() => {
        "optionType": tionTypeValues.reverse[optionType],
        "isCorrect": isCorrect,
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "imageUrl": imageUrl,
        "audioUrl": audioUrl,
    };
}

enum TionType {
    SENTENCE,
    WORD
}

final tionTypeValues = EnumValues({
    "sentence": TionType.SENTENCE,
    "word": TionType.WORD
});

enum Language {
    ENGLISH,
    VIETNAMESE
}

final languageValues = EnumValues({
    "english": Language.ENGLISH,
    "vietnamese": Language.VIETNAMESE
});

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

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
