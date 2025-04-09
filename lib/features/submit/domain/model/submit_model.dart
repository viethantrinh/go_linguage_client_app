class SubmitRequestModel {
  int xpPoints;
  int goPoints;
  SubmitType type;
  int id;

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
