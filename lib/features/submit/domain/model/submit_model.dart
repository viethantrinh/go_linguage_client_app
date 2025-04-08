class SubmitRequestModel {
  final int xpPoints;
  final int goPoints;
  final SubmitType type;
  final int id;

  SubmitRequestModel(
      {required this.xpPoints,
      required this.goPoints,
      required this.type,
      required this.id});
}

enum SubmitType {
  dialog,
  lesson,
}
