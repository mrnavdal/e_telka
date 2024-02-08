import 'package:e_telka/core/util/date_util.dart';
import 'package:e_telka/tasks/domain/entities/task.dart';
import 'package:e_telka/tasks/domain/repositories/tasks_repository.dart';
import 'package:e_telka/tasks/presentation/tasks_state.dart';
import 'package:get/get.dart';

class TasksController extends GetxController {
  final TasksRepository tasksRepository = Get.find();

  final DateUtil dateUtil = Get.find();

  Rx<TasksState> state = TasksState('TasksState').obs;
  var index = 0.obs;
  RxList<Task> tasks = <Task>[].obs;
  RxList<Task> allTasks = <Task>[].obs;

  Task? getFollowingTask(Task task) => tasksRepository.getFollowingTask(task);
  Task? getPreviousTask(Task task) => tasksRepository.getPreviousTask(task);
  List<String> filteredOperations = <String>[];
  List<String> filteredStates = <String>['Zahájené úkoly', 'Nezahájené úkoly'];
  String selectedSortingFactor = 'Čísla úkolu';
  bool ascendingOrder = true;
  bool areTasksFiltered = false;

  List<Task> get delayedTasks => tasks
      .where((task) => task.plannedEndDate != null)
      .where((task) => dateUtil.isDateBeforeThisWeek(task.plannedEndDate!))
      .toList();

  List<Task> get currentWeekTasks => tasks
      .where((task) => task.plannedEndDate != null)
      .where((task) => dateUtil.isDateInThisWeek(task.plannedEndDate!))
      .toList();
  List<Task> get upcomingTasks => tasks
      .where((task) => task.plannedEndDate != null)
      .where((task) => dateUtil.isDateAfterThisWeek(task.plannedEndDate!))
      .toList();

  Future<void> initializeTasks() async {
    allTasks.value = await tasksRepository.getUsersActiveTasks();
    filteredOperations =
        allTasks.value.map((e) => e.operation).toSet().toList();
    filterTasks();
  }

  Future<void> refreshTasks() async {
    allTasks.value = await tasksRepository.getUsersActiveTasks();
    tasks = allTasks;
    if (areTasksFiltered) {
      filterTasks();
    }
    update();
  }

  disableFilters() => tasks = allTasks;

  void filterTasks() async {
    tasks = allTasks;
    filterOperations();
    filterStates();
    sortTasks();
    update();
  }

  filterOperations() {
    tasks = tasks
        .where((task) => filteredOperations.contains(task.operation))
        .toList()
        .obs;
  }

  filterStates() {
    var tasksFilteredByStates = <Task>[];
    if (filteredStates.contains('Zahájené úkoly')) {
      tasksFilteredByStates
          .addAll(tasks.where((task) => task.startedDate != null));
    }
    if (filteredStates.contains('Nezahájené úkoly')) {
      tasksFilteredByStates
          .addAll(tasks.where((task) => task.startedDate == null));
    }
    tasks = tasksFilteredByStates.obs;
  }

  sortTasks() {
    switch (selectedSortingFactor) {
      case 'Počtu ks':
        tasks.sort((a, b) => ascendingOrder
            ? a.pieces.compareTo(b.pieces)
            : b.pieces.compareTo(a.pieces));
        break;
      case 'Čísla úkolu':
        tasks.sort((a, b) => ascendingOrder
            ? a.taskId.compareTo(b.taskId)
            : b.taskId.compareTo(a.taskId));
        break;
      case 'Pořadí operace':
        tasks.sort((a, b) => ascendingOrder
            ? a.operationOrderNumber.compareTo(b.operationOrderNumber)
            : b.operationOrderNumber.compareTo(a.operationOrderNumber));
        break;
      case 'Plánu \ndokončení':
        // create a sorting algorithm for task.realizedEndDate which is nullable
        tasks.sort((a, b) {
          final aPlannedEndDate = a.plannedEndDate ?? DateTime(2021, 1, 1);
          final bPlannedEndDate = b.plannedEndDate ?? DateTime(2021, 1, 1);
          if (ascendingOrder) {
            return aPlannedEndDate.compareTo(bPlannedEndDate);
          } else {
            return bPlannedEndDate.compareTo(aPlannedEndDate);
          }
        });
        break;
      default:
    }
  }

  void onSortingFactorChange(String value) {
    selectedSortingFactor = value;
    update(); // Update the state so that the value is available to views
  }

  void onSortingOrderChange(bool ascending) {
    ascendingOrder = ascending;
    update(); // Update the state so that the value is available to views
  }

  Future<void> finishTask(Task? task) async {
    if (task != null) {
      await tasksRepository.finishTask(task);
      refreshTasks();
    }
  }

  Future<void> setTaskToStarted(Task? task) async {
    if (task != null) {
      await tasksRepository.setTaskToStarted(task);
      refreshTasks();
    }
  }

  void activateSewingAndPriceTasks(Task task) {
    final taskListID = task.taskId;
    // get all tasks with the same taskListID
    final ukolakTasks =
        tasksRepository.allTasks.where((element) => element.taskId == taskListID).toList();
    // make sewing tasks that come first active (901 is the order number of the first sewing task)
    for (var task in ukolakTasks) {
      if (['štep', 'obnitka', 'pevný', 'flatlock'].contains(task.operation) && task.operationOrderNumber == 901) {
        task.isActive = true;
        tasksRepository.updateTask(task);
      }
      if (task.operation == 'cena + rozdělovník') {
        task.isActive = true;
        tasksRepository.updateTask(task);
      }
    }
    refreshTasks();
  }
}
