part of 'timing_bloc.dart';

abstract class TimingEven extends Equatable {
  const TimingEven();

  @override
  List<Object?> get props => [];
}

class SetMorningTime extends TimingEven {
  final Timing notification;

  const SetMorningTime({required this.notification});

  @override
  List<Object?> get props => [notification];
}

class SetAfternoonTime extends TimingEven {
  final Timing notification;

  const SetAfternoonTime({required this.notification});

  @override
  List<Object?> get props => [notification];
}

class SetEveningTime extends TimingEven {
  final Timing notification;

  const SetEveningTime({required this.notification});

  @override
  List<Object?> get props => [notification];
}