class Report {
  final int id;
  final String img;
  final String desc;
  final String tag;
  // ignore: non_constant_identifier_names
  final int user_id;

  // ignore: non_constant_identifier_names
  Report({this.id, this.img, this.desc, this.tag, this.user_id});

  factory Report.fromJson(Map<String, dynamic> json) {
    return new Report(
        id: json['id'],
        img: json['img'],
        desc: json['desc'],
        tag: json['tag'],
        user_id: json['user_id']);
  }
}
