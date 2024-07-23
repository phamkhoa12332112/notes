import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../models/task.dart';

part 'tasks_even.dart';

part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEven, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onAddTask(AddTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(allTasks: List.from(state.allTasks)..add(even.task)));
  }

  void _onUpdateTask(UpdateTask even, Emitter<TasksState> emit) {}

  void _onDeleteTask(DeleteTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(allTasks: List.from(state.allTasks)..remove(even.task)));
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}