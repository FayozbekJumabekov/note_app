class Note {
  late int id;
  late DateTime createTime;
  late DateTime editTime;
  late String title;
  late String content;
 static List<Note> noteList = [];
  Note({
    required this.id,
    required this.createTime,
    required this.editTime,
    required this.title,
    required this.content,
  });

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = DateTime.parse(json['createTime']);
    editTime = DateTime.parse(json['editTime']);
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createTime': createTime.toString(),
        'editTime': editTime.toString(),
        'title': title,
        'content': content,
      };
}
