import 'package:flutter/material.dart';

class DrawingPoint {
  int id;
  List<Offset> offsets;
  Color color;
  double width;

  DrawingPoint({
    this.id = -1,
    this.offsets = const [],
    this.color = Colors.black,
    this.width = 2,
  });

  DrawingPoint copyWith({List<Offset>? offsets}) {
    return DrawingPoint(
        id: id, offsets: offsets ?? this.offsets, color: color, width: width);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'offsets': offsets.map((offset) => {'dx': offset.dx, 'dy': offset.dy}).toList(),
      'width': width,
      'color': color.value,
    };
  }

  factory DrawingPoint.fromMap(Map<String, dynamic> map) {
    return DrawingPoint(
      id: map['id'],
      offsets: List<Offset>.from(
        (map['offsets']).map(
              (offset) => Offset(offset['dx'], offset['dy']),
        ),
      ),
      width: map['width'],
      color: Color(map['color']),
    );
  }
}