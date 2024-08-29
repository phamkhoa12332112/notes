part of 'timing_bloc.dart';

class TimingState extends Equatable {
  late final DateTime morning;
  late final DateTime afternoon;
  late final DateTime evening;

  TimingState({
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

  @override
  List<Object?> get props => [morning, afternoon, evening];

  Map<String, dynamic> toMap() {
    return {
      'morning': morning.toIso8601String(),
      'afternoon': afternoon.toIso8601String(),
      'evening': evening.toIso8601String(),
    };
  }

  factory TimingState.fromMap(Map<String, dynamic> map) {
    return TimingState(
      morning: DateTime.parse(map['morning']),
      afternoon: DateTime.parse(map['afternoon']),
      evening: DateTime.parse(map['evening']),
    );
  }
}