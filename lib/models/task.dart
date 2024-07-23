import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final String content;
  bool? isDone;
  bool? isDelete;

  Task(
      {required this.title,
      required this.content,
      this.isDone,
      this.isDelete}) {
    isDone = isDone ?? false;
    isDelete = isDelete ?? false;
  }

  Task copyWith({
    String? title,
    String? content,
    bool? isDone,
    bool? isDelete,
  }) {
    return Task(
        title: title ?? this.title,
        content: content ?? this.content,
        isDone: isDone ?? this.isDone,
        isDelete: isDelete ?? this.isDelete);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'isDone': isDone,
      'isDelete': isDelete
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        title: map['title'] ?? "",
        content: map['content'] ?? "",
        isDone: map['isDone'],
        isDelete: map['isDelete']);
  }

  @override
  List<Object?> get props => [title, content, isDone, isDelete];
}