import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../models/timing.dart';

part 'timing_even.dart';

part 'timing_state.dart';

class TimingBloc
    extends HydratedBloc<TimingEven, TimingState> {
  TimingBloc() : super(TimingState()) {
    on<SetMorningTime>(_setMorningTime);
    on<SetAfternoonTime>(_setAfternoonTime);
    on<SetEveningTime>(_setEveningTime);
  }

  void _setMorningTime(SetMorningTime even, Emitter<TimingState> emit) {
    emit(TimingState(
        morning: even.notification.morning,
        afternoon: state.afternoon,
        evening: state.evening));
  }

  void _setAfternoonTime(SetAfternoonTime even, Emitter<TimingState> emit) {
    emit(TimingState(
        morning: state.morning,
        afternoon: even.notification.afternoon,
        evening: state.evening));
  }

  void _setEveningTime(SetEveningTime even, Emitter<TimingState> emit) {
    emit(TimingState(
        morning: state.morning,
        afternoon: state.afternoon,
        evening: even.notification.evening));
  }

  @override
  TimingState? fromJson(Map<String, dynamic> json) {
    return TimingState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TimingState state) {
    return state.toMap();
  }
}