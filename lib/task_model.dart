import 'dart:convert';

class Task {
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  factory Task.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Task(
      title: jsonMap['title'],
      description: jsonMap['description'],
      isCompleted: jsonMap['isCompleted'] ?? false,
    );
  }
}
