import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../models/task.dart';

part 'tasks_even.dart';

part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEven, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<EditTask>(_onEditTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
  }

  void _onAddTask(AddTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: List.from(state.allTasks)..add(even.task),
        deleteTasks: state.deleteTasks));
  }

  void _onEditTask(EditTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: List.from(state.allTasks)
          ..remove(even.oldTask)
          ..insert(0, even.newTask),
        deleteTasks: state.deleteTasks));
  }

  void _onDeleteTask(DeleteTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: List.from(state.allTasks)..remove(even.task),
        deleteTasks: List.from(state.deleteTasks)..remove(even.task)));
  }

  void _onRemoveTask(RemoveTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: List.from(state.allTasks)..remove(even.task),
        deleteTasks: List.from(state.deleteTasks)
          ..insert(0, even.task.copyWith(isDelete: true, isDone: false))));
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