import 'package:equatable/equatable.dart';

class Timing extends Equatable {
  final DateTime morning;
  final DateTime afternoon;
  final DateTime evening;

  Timing({
    DateTime? morning,
    DateTime? afternoon,
    DateTime? evening,
  })  : morning = morning ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 8, 0),
        afternoon = afternoon ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 13, 0),
        evening = evening ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 18, 0);

  Map<String, dynamic> toMap() {
    return {
      'morning': morning,
      'afternoon': afternoon,
      'evening': evening,
    };
  }

  factory Timing.fromMap(Map<String, dynamic> map) {
    return Timing(
      morning: map['morning'],
      afternoon: map['afternoon'],
      evening: map['evening'],
    );
  }

  @override
  List<Object?> get props => [morning, afternoon, evening];
}