import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Task extends Equatable {
  final String title;
  final String content;
  bool isChoose = false;
  bool? isDelete;
  bool? isStore;
  bool? isPin;
  List<String> labelsList;
  Map<IconData, Map<String, DateTime>> notifications;

  Task(
      {required this.title,
      required this.content,
      required this.isChoose,
      required this.labelsList,
      required this.notifications,
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
      bool? isPin,
      List<String>? labelsList,
      Map<IconData, Map<String, DateTime>>? notifications}) {
    return Task(
        title: title ?? this.title,
        content: content ?? this.content,
        isChoose: isChoose ?? this.isChoose,
        isDelete: isDelete ?? this.isDelete,
        isStore: isStore ?? this.isStore,
        isPin: isPin ?? this.isPin,
        labelsList: labelsList ?? this.labelsList,
        notifications: notifications ?? this.notifications);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'isChoose': isChoose,
      'isDelete': isDelete,
      'isStore': isStore,
      'isPin': isPin,
      'labelsList': labelsList,
      'notifications': notifications
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        title: map['title'] ?? "",
        content: map['content'] ?? "",
        isChoose: map['isChoose'],
        isDelete: map['isDelete'],
        isStore: map['isStore'],
        isPin: map['isPin'],
        labelsList: map['labelsList'],
        notifications: map['notifications']);
  }

  @override
  List<Object?> get props => [
        title,
        content,
        isChoose,
        isDelete,
        isStore,
        isPin,
        labelsList,
        notifications
      ];
}
