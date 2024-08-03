part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final List<Task> allTasks;
  final List<Task> deleteTasks;
  final List<Task> storeTasks;
  final List<Task> pinTasks;

  const TasksState(
      {this.allTasks = const <Task>[],
      this.deleteTasks = const <Task>[],
      this.storeTasks = const <Task>[],
      this.pinTasks = const <Task>[]});

  @override
  List<Object?> get props => [allTasks, deleteTasks, storeTasks, pinTasks];

  Map<String, dynamic> toMap() {
    return {
      'allTask': allTasks.map((x) => x.toMap()).toList(),
      'deleteTasks': deleteTasks.map((x) => x.toMap()).toList(),
      'storeTasks': storeTasks.map((x) => x.toMap()).toList(),
      'pinTasks': pinTasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
      allTasks: List<Task>.from(map['allTasks']?.map((x) => Task.fromMap(x))),
      deleteTasks:
          List<Task>.from(map['deleteTasks']?.map((x) => Task.fromMap(x))),
      storeTasks:
          List<Task>.from(map['storeTasks']?.map((x) => Task.fromMap(x))),
      pinTasks: List<Task>.from(map['pinTasks']?.map((x) => Task.fromMap(x))),
    );
  }
}