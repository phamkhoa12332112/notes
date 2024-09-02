import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notesapp/models/task.dart';

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
    on<PinTask>(_onPinTask);
    on<RemovePinTask>(_onRemovePinTask);
    on<RestorePinTask>(_onRestorePinTask);
    on<AddLabelTask>(_onAddLabelTask);
    on<AddLabelList>(_onAddLabelList);
    on<RemoveLabel>(_onRemoveLabel);
    on<EditLabel>(_onEditLabel);
    on<DuplicateNote>(_onDuplicateNote);
    on<SearchTasks>(_onSearchTasks);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;

    final updatedAllTasks = List<Task>.from(state.allTasks)..add(event.task);
    final updatedSearchTasks = List<Task>.from(state.searchTasks)
      ..add(event.task);

    emit(TasksState(
        allTasks: updatedAllTasks,
        deleteTasks: state.deleteTasks,
        storeTasks: state.storeTasks,
        pinTasks: state.pinTasks,
        searchTasks: updatedSearchTasks,
        labelListTasks: state.labelListTasks));
  }

  void _onEditTask(EditTask even, Emitter<TasksState> emit) {
    final state = this.state;
    final List<Task> listTasks = even.oldTask.isStore
        ? state.allTasks
        : even.newTask.isPin
            ? state.allTasks
            : (List.from(state.allTasks)
              ..remove(even.oldTask)
              ..insert(0, even.newTask));
    final List<Task> storeTasks = even.oldTask.isStore
        ? (List.from(state.storeTasks)
          ..remove(even.oldTask)
          ..insert(0, even.newTask))
        : state.storeTasks;
    final List<Task> pinTasks = even.newTask.isPin
        ? (List.from(state.pinTasks)
          ..remove(even.oldTask)
          ..insert(0, even.newTask))
        : state.pinTasks;
    final List<Task> searchTasks = List.from(state.searchTasks)
      ..remove(even.oldTask)
      ..insert(0, even.newTask);
    final Map<String, List<Task>> labelsList =
        Map<String, List<Task>>.from(state.labelListTasks);
    even.newTask.labelsList.forEach((label) {
      if (!even.oldTask.labelsList.contains(label)) {
        labelsList[label] = List.from(labelsList[label]!)
          ..remove(even.oldTask)
          ..add(even.newTask);
      }
    });
    emit(TasksState(
        allTasks: listTasks,
        deleteTasks: state.deleteTasks,
        storeTasks: storeTasks,
        pinTasks: pinTasks,
        searchTasks: searchTasks,
        labelListTasks: labelsList));
  }

  void _onDeleteTask(DeleteTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: List.from(state.allTasks)..remove(even.task),
        deleteTasks: List.from(state.deleteTasks)..remove(even.task),
        storeTasks: state.storeTasks,
        pinTasks: List.from(state.pinTasks)..remove(even.task),
        searchTasks: List.from(state.searchTasks)..remove(even.task),
        labelListTasks: state.labelListTasks));
  }

  void _onRemoveTask(RemoveTask even, Emitter<TasksState> emit) {
    final state = this.state;
    final Map<String, List<Task>> labelListTasks =
        Map<String, List<Task>>.from(state.labelListTasks);
    even.task.labelsList.forEach((label) {
      labelListTasks[label]?.remove(even.task);
    });
    emit(TasksState(
        allTasks: List.from(state.allTasks)..remove(even.task),
        deleteTasks: List.from(state.deleteTasks)
          ..insert(0, even.task.copyWith(isDelete: true, isChoose: false)),
        storeTasks: List.from(state.storeTasks)..remove(even.task),
        pinTasks: List.from(state.pinTasks)..remove(even.task),
        searchTasks: List.from(state.searchTasks)..remove(even.task),
        labelListTasks: labelListTasks));
  }

  void _onRestoreTask(RestoreTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        deleteTasks: List.from(state.deleteTasks)..remove(even.task),
        allTasks: List.from(state.allTasks)
          ..insert(
              0,
              even.task
                  .copyWith(isDelete: false, isChoose: false, isPin: false)),
        storeTasks: state.storeTasks,
        pinTasks: state.pinTasks,
        searchTasks: List.from(state.searchTasks)
          ..insert(
              0,
              even.task
                  .copyWith(isDelete: false, isChoose: false, isPin: false)),
        labelListTasks: state.labelListTasks));
  }

  void _onDuplicateNote(DuplicateNote even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        deleteTasks: state.deleteTasks,
        allTasks: List.from(state.allTasks)..add(even.task),
        storeTasks: state.storeTasks,
        pinTasks: state.pinTasks,
        searchTasks: List.from(state.searchTasks)..add(even.task),
        labelListTasks: state.labelListTasks));
  }

  void _onStoreTask(StoreTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        storeTasks: List.from(state.storeTasks)
          ..add(even.newTask.copyWith(isStore: true, isPin: false)),
        deleteTasks: List.from(state.deleteTasks),
        allTasks: List.from(state.allTasks)..remove(even.oldTask),
        pinTasks: List.from(state.pinTasks)..remove(even.oldTask),
        searchTasks: List.from(state.searchTasks)..remove(even.oldTask),
        labelListTasks: state.labelListTasks));
  }

  void _onUnStoreTask(UnStoreTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        deleteTasks: List.from(state.deleteTasks),
        storeTasks: List.from(state.storeTasks)..remove(even.task),
        allTasks: List.from(state.allTasks)
          ..add(even.task.copyWith(isStore: false, isChoose: false)),
        pinTasks: state.pinTasks,
        searchTasks: List.from(state.searchTasks)
          ..add(even.task.copyWith(isStore: false, isChoose: false)),
        labelListTasks: state.labelListTasks));
  }

  void _onPinTask(PinTask even, Emitter<TasksState> emit) {
    final state = this.state;
    List<Task> storeTasks = even.oldTask.isStore
        ? (List.from(state.storeTasks)..remove(even.oldTask))
        : state.storeTasks;
    List<Task> allTasks = even.oldTask.isStore
        ? state.allTasks
        : (List.from(state.allTasks)
          ..remove(even.oldTask.copyWith(isPin: !even.oldTask.isPin)));
    emit(TasksState(
        pinTasks: List.from(state.pinTasks)
          ..add(even.newTask.copyWith(isStore: false)),
        deleteTasks: List.from(state.deleteTasks),
        storeTasks: storeTasks,
        allTasks: allTasks,
        searchTasks: List.from(state.searchTasks)
          ..remove(even.oldTask.copyWith(isPin: !even.oldTask.isPin))
          ..add(even.newTask.copyWith(isStore: false)),
        labelListTasks: state.labelListTasks));
  }

  void _onRemovePinTask(RemovePinTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: state.allTasks,
        deleteTasks: state.deleteTasks,
        storeTasks: state.storeTasks,
        pinTasks: List.from(state.pinTasks)..remove(even.task),
        searchTasks: List.from(state.searchTasks)..remove(even.task),
        labelListTasks: state.labelListTasks));
  }

  void _onRestorePinTask(RestorePinTask even, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
        allTasks: List.from(state.allTasks)..remove(even.task),
        deleteTasks: state.deleteTasks,
        storeTasks: state.storeTasks,
        pinTasks: state.pinTasks,
        searchTasks: List.from(state.searchTasks)..remove(even.task),
        labelListTasks: state.labelListTasks));
  }

  void _onAddLabelTask(AddLabelTask even, Emitter<TasksState> emit) {
    final state = this.state;
    final Map<String, List<Task>> labelsTaskList =
        Map<String, List<Task>>.from(state.labelListTasks);
    even.task.labelsList.forEach((label) {
      if (!labelsTaskList[label]!.contains(even.task)) {
        labelsTaskList[label] = [even.task];
      }
    });
    emit(TasksState(
        allTasks: state.allTasks,
        deleteTasks: state.deleteTasks,
        storeTasks: state.storeTasks,
        pinTasks: state.pinTasks,
        searchTasks: state.searchTasks,
        labelListTasks: labelsTaskList));
  }

  void _onAddLabelList(AddLabelList even, Emitter<TasksState> emit) {
    final state = this.state;
    final Map<String, List<Task>> labelsTaskList =
        Map<String, List<Task>>.from(state.labelListTasks);
    labelsTaskList[even.label] = [];
    emit(TasksState(
        allTasks: state.allTasks,
        deleteTasks: state.deleteTasks,
        storeTasks: state.storeTasks,
        pinTasks: state.pinTasks,
        searchTasks: state.searchTasks,
        labelListTasks: labelsTaskList));
  }

  void _onRemoveLabel(RemoveLabel even, Emitter<TasksState> emit) {
    final state = this.state;
    final Map<String, List<Task>> labelsTaskList =
        Map<String, List<Task>>.from(state.labelListTasks);
    labelsTaskList.remove(even.label);
    emit(TasksState(
        allTasks: state.allTasks,
        deleteTasks: state.deleteTasks,
        storeTasks: state.storeTasks,
        pinTasks: state.pinTasks,
        searchTasks: state.searchTasks,
        labelListTasks: labelsTaskList));
  }

  void _onEditLabel(EditLabel even, Emitter<TasksState> emit) {
    final state = this.state;
    final Map<String, List<Task>> labelsTaskList =
        Map<String, List<Task>>.from(state.labelListTasks);
    if (labelsTaskList.containsKey(even.oldLabel)) {
      final List<Task> tasks = labelsTaskList[even.oldLabel]!;
      labelsTaskList.remove(even.oldLabel);
      labelsTaskList[even.newLabel] = tasks;
    }
    emit(TasksState(
        allTasks: state.allTasks,
        deleteTasks: state.deleteTasks,
        storeTasks: state.storeTasks,
        pinTasks: state.pinTasks,
        searchTasks: state.searchTasks,
        labelListTasks: labelsTaskList));
  }

  void _onSearchTasks(SearchTasks event, Emitter<TasksState> emit) {
    final query = event.query.toLowerCase();

    List<Task> filteredTasks = [];

    if (query.isNotEmpty) {
      filteredTasks.addAll(state.allTasks.where((task) {
        var deltaJson = jsonDecode(task.content);
        StringBuffer normalText = StringBuffer();
        for (var operation in deltaJson) {
          normalText.write(operation['insert']);
        }

        return task.title.toLowerCase().contains(query) ||
            normalText.toString().toLowerCase().contains(query);
      }).toList());
      filteredTasks.addAll(state.pinTasks.where((task) {
        var deltaJson = jsonDecode(task.content);
        StringBuffer normalText = StringBuffer();
        for (var operation in deltaJson) {
          normalText.write(operation['insert']);
        }

        return task.title.toLowerCase().contains(query) ||
            normalText.toString().toLowerCase().contains(query);
      }).toList());
    } else {
      filteredTasks.addAll(state.allTasks);
      filteredTasks.addAll(state.pinTasks);
    }

    emit(TasksState(
      allTasks: state.allTasks,
      deleteTasks: state.deleteTasks,
      storeTasks: state.storeTasks,
      pinTasks: state.pinTasks,
      searchTasks: filteredTasks,
      labelListTasks: state.labelListTasks,
    ));
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
