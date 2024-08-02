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
    on<RestoreTask>(_onRestoreTask);
    on<StoreTask>(_onStoreTask);
    on<UnStoreTask>(_onUnStoreTask);
  }

  void _onAddTask(AddTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: List.from(state.allTasks)..add(even.task),
        deleteTasks: state.deleteTasks,
        storeTasks: state.storeTasks));
  }

  void _onEditTask(EditTask even, Emitter<TasksState> emit) {
    final state = this.state;
    final List<Task> listTasks = even.oldTask.isStore!
        ? state.allTasks
        : (List.from(state.allTasks)
          ..remove(even.oldTask)
          ..insert(0, even.newTask));
    final List<Task> storeTasks = even.oldTask.isStore!
        ? (List.from(state.storeTasks)
          ..remove(even.oldTask)
          ..insert(0, even.newTask))
        : state.storeTasks;
    emit(TasksState(
        allTasks: listTasks,
        deleteTasks: state.deleteTasks,
        storeTasks: storeTasks));
  }

  void _onDeleteTask(DeleteTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: List.from(state.allTasks)..remove(even.task),
        deleteTasks: List.from(state.deleteTasks)..remove(even.task),
        storeTasks: state.storeTasks));
  }

  void _onRemoveTask(RemoveTask even, Emitter<TasksState> emit) {
    final state = this.state;

    emit(TasksState(
        allTasks: List.from(state.allTasks)..remove(even.task),
        deleteTasks: List.from(state.deleteTasks)
          ..insert(0, even.task.copyWith(isDelete: true, isChoose: false)),
        storeTasks: List.from(state.storeTasks)..remove(even.task)));
  }

  void _onRestoreTask(RestoreTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        deleteTasks: List.from(state.deleteTasks)..remove(even.task),
        allTasks: List.from(state.allTasks)
          ..insert(0, even.task.copyWith(isDelete: false, isChoose: false)),
        storeTasks: state.storeTasks));
  }

  void _onStoreTask(StoreTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        storeTasks: List.from(state.storeTasks)
          ..add(even.task.copyWith(isStore: true)),
        deleteTasks: List.from(state.deleteTasks),
        allTasks: List.from(state.allTasks)));
  }

  void _onUnStoreTask(UnStoreTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        deleteTasks: List.from(state.deleteTasks),
        storeTasks: List.from(state.storeTasks)..remove(even.task),
        allTasks: List.from(state.allTasks)
          ..add(even.task.copyWith(isStore: false))));
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