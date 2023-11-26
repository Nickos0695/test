class Note {
  final int id;
  final String title;
  final String text;

  Note({
    required this.id,
    required this.title,
    required this.text,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
    };
  }
}