import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'drawing_point.dart';

class Task extends Equatable {
  final String title;
  final String content;
  bool isChoose = false;
  bool? isDelete;
  bool isStore;
  bool isPin;
  Color? color;
  String? editedTime;
  List<String> labelsList;
  Map<IconData, Map<String, DateTime>> notifications;
  String? duration;
  Map<String, bool>? checkBoxList;
  List<File>? selectedImage;
  List<DrawingPoint>? drawingPoint;
  String? recordingPath;

  Task({
    required this.title,
    required this.content,
    required this.isChoose,
    required this.labelsList,
    required this.notifications,
    this.duration,
    this.editedTime,
    this.isDelete,
    required this.isStore,
    required this.isPin,
    this.checkBoxList,
    this.selectedImage,
    this.drawingPoint,
    this.recordingPath,
    this.color,
  }) {
    isDelete = isDelete ?? false;
    editedTime = editedTime ?? "";
    duration = duration ?? "";
    checkBoxList = checkBoxList ?? {};
    selectedImage = selectedImage ?? [];
    drawingPoint = drawingPoint ?? [];
    recordingPath = recordingPath ?? "";
    color = color;
  }

  Task copyWith({
    String? title,
    String? content,
    bool? isChoose,
    bool? isDelete,
    bool? isStore,
    bool? isPin,
    Color? color,
    String? editedTime,
    List<String>? labelsList,
    Map<IconData, Map<String, DateTime>>? notifications,
    String? duration,
    Map<String, bool>? checkBoxList,
    List<File>? selectedImage,
    List<DrawingPoint>? drawingPoint,
    String? recordingPath,
  }) {
    return Task(
      title: title ?? this.title,
      content: content ?? this.content,
      isChoose: isChoose ?? this.isChoose,
      isDelete: isDelete ?? this.isDelete,
      isStore: isStore ?? this.isStore,
      isPin: isPin ?? this.isPin,
      color: color ?? this.color,
      editedTime: editedTime ?? this.editedTime,
      labelsList: labelsList ?? this.labelsList,
      notifications: notifications ?? this.notifications,
      duration: duration ?? this.duration,
      checkBoxList: checkBoxList ?? this.checkBoxList,
      selectedImage: selectedImage ?? this.selectedImage,
      drawingPoint: drawingPoint ?? this.drawingPoint,
      recordingPath: recordingPath ?? this.recordingPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'isChoose': isChoose,
      'isDelete': isDelete,
      'isStore': isStore,
      'isPin': isPin,
      'color': color?.value,
      'editedTime': editedTime,
      'labelsList': labelsList,
      'notifications': notifications,
      'duration': duration,
      'checkBoxList': checkBoxList,
      'selectedImage': selectedImage?.map((file) => file.path).toList(),
      'drawingPoint': drawingPoint?.map((point) => point.toMap()).toList(),
      'recordingPath': recordingPath,
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
      color: Color(map['color']),
      editedTime: map['editedTime'],
      labelsList: map['labelsList'],
      notifications: map['notifications'],
      duration: map['duration'],
      checkBoxList: map['checkBoxList'],
      selectedImage: map['selectedImage'],
      drawingPoint: (map['drawingPoint'] as List)
          .map((pointMap) => DrawingPoint.fromMap(pointMap))
          .toList(),
      recordingPath: map['recordingPath'],
    );
  }

  @override
  List<Object?> get props => [
        title,
        content,
        isChoose,
        isDelete,
        isStore,
        isPin,
        color,
        editedTime,
        labelsList,
        notifications,
        duration,
        checkBoxList,
        selectedImage,
        drawingPoint,
        recordingPath,
      ];
}