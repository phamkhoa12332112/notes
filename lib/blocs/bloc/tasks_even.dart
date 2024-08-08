part of 'tasks_bloc.dart';

abstract class TasksEven extends Equatable {
  const TasksEven();

  @override
  List<Object?> get props => [];
}

class AddTask extends TasksEven {
  final Task task;

  const AddTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class EditTask extends TasksEven {
  final Task oldTask;
  final Task newTask;

  const EditTask({required this.oldTask, required this.newTask});

  @override
  List<Object?> get props => [oldTask, newTask];
}

class DeleteTask extends TasksEven {
  final Task task;

  const DeleteTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class RemoveTask extends TasksEven {
  final Task task;

  const RemoveTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class RestoreTask extends TasksEven {
  final Task task;

  const RestoreTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class StoreTask extends TasksEven {
  final Task task;

  const StoreTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class UnStoreTask extends TasksEven {
  final Task task;

  const UnStoreTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class PinTask extends TasksEven {
  final Task task;

  const PinTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class RemovePinTask extends TasksEven {
  final Task task;

  const RemovePinTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class RestorePinTask extends TasksEven {
  final Task task;

  const RestorePinTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class AddLabelTask extends TasksEven {
  final Task task;

  const AddLabelTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class AddLabelList extends TasksEven {
  final String label;

  const AddLabelList({required this.label});

  @override
  List<Object?> get props => [label];
}

class RemoveLabel extends TasksEven {
  final String label;

  const RemoveLabel({required this.label});

  @override
  List<Object?> get props => [label];
}