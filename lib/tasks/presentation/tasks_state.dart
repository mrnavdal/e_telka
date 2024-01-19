import 'package:equatable/equatable.dart';

class TasksState extends Equatable {
  String message;
  TasksState(this.message);

  @override
  List<Object> get props => [message];
}

class TasksLoading extends TasksState {
  TasksLoading() : super('Loading');
}

class TasksError extends TasksState {
  TasksError() : super('Error');
}

class TasksMyTasks extends TasksState {
  TasksMyTasks() : super('MyTasks');
}

class TasksFreeTasks extends TasksState {
  TasksFreeTasks() : super('FreeTasks');
}

class TasksOverview extends TasksState {
  TasksOverview() : super('Overview');
}
