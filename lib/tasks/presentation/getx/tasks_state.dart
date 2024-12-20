import 'package:equatable/equatable.dart';

class TasksState extends Equatable {
  String message;
  TasksState(this.message);

  @override
  List<Object> get props => [message];
}

class TasksLoading extends TasksState {
  TasksLoading() : super('Načítám...');
}

class TasksError extends TasksState {
  @override
  final String message;

  TasksError(this.message) : super('Něco se pokazilo');
}

class TasksMyTasks extends TasksState {
  TasksMyTasks() : super('Moje úkoly');
}

class TasksFreeTasks extends TasksState {
  TasksFreeTasks() : super('FreeTasks');
}

class TasksOverview extends TasksState {
  TasksOverview() : super('Všechny úkoly');
}
