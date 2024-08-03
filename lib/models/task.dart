import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final String content;
  bool isChoose = false;
  bool? isDelete;
  bool? isStore;
  bool? isPin;

  Task(
      {required this.title,
      required this.content,
      required this.isChoose,
      this.isDelete,
      this.isStore,
      this.isPin}) {
    isDelete = isDelete ?? false;
    isStore = isStore ?? false;
    isPin = isPin ?? false;
  }

  Task copyWith(
      {String? title,
      String? content,
      bool? isChoose,
      bool? isDelete,
      bool? isStore,
      bool? isPin}) {
    return Task(
        title: title ?? this.title,
        content: content ?? this.content,
        isChoose: isChoose ?? this.isChoose,
        isDelete: isDelete ?? this.isDelete,
        isStore: isStore ?? this.isStore,
        isPin: isPin ?? this.isPin);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'isChoose': isChoose,
      'isDelete': isDelete,
      'isStore': isStore,
      'isPin': isPin
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        title: map['title'] ?? "",
        content: map['content'] ?? "",
        isChoose: map['isChoose'],
        isDelete: map['isDelete'],
        isStore: map['isStore'],
        isPin: map['isPin']);
  }

  @override
  List<Object?> get props => [title, content, isChoose, isDelete, isStore, isPin];
}