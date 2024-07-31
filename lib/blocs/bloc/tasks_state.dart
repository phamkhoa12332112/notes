part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final List<Task> allTasks;
  final List<Task> deleteTasks;

  const TasksState(
      {this.allTasks = const <Task>[], this.deleteTasks = const <Task>[]});

  @override
  List<Object?> get props => [allTasks, deleteTasks];

  Map<String, dynamic> toMap() {
    return {
      'allTask': allTasks.map((x) => x.toMap()).toList(),
      'deleteTasks': deleteTasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
      allTasks: List<Task>.from(map['allTasks']?.map((x) => Task.fromMap(x))),
      deleteTasks:
          List<Task>.from(map['deleteTasks']?.map((x) => Task.fromMap(x))),
    );
  }
}