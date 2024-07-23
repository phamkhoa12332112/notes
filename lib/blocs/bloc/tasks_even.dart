part of 'tasks_bloc.dart';


abstract class TasksEven extends Equatable {
  const TasksEven();

  @override
  List<Object?> get props => [];
}

class AddTask extends TasksEven {
  final Task task;

  const AddTask({
    required this.task
  });

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TasksEven {
  final Task task;

  const UpdateTask({
    required this.task
  });

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TasksEven {
  final Task task;

  const DeleteTask({
    required this.task
  });

  @override
  List<Object?> get props => [task];
}