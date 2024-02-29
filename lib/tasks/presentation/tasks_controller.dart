import 'dart:async';

import 'package:e_telka/core/util/date_util.dart';
import 'package:e_telka/tasks/domain/entities/workshop_task.dart';
import 'package:e_telka/tasks/domain/entities/workshop_worker.dart';
import 'package:e_telka/tasks/domain/repositories/tasks_repository.dart';
import 'package:e_telka/tasks/presentation/tasks_state.dart';
import 'package:get/get.dart';

class TasksController extends GetxController {
  final TasksRepository tasksRepository = Get.find();

  final DateUtil dateUtil = Get.find();
  List<WorkshopWorker> workers = <WorkshopWorker>[];

  Rx<TasksState> state = TasksMyTasks().obs;
  var index = 0.obs;
  RxList<WorkshopTask> displayedTasks = <WorkshopTask>[].obs;
  RxList<WorkshopTask> usersTasks = <WorkshopTask>[].obs;
  RxList<WorkshopTask> activeTasks = <WorkshopTask>[].obs;
  WorkshopTask? getFollowingTask(WorkshopTask task) =>
      tasksRepository.getFollowingTask(task);
  WorkshopTask? getPreviousTask(WorkshopTask task) =>
      tasksRepository.getPreviousTask(task);
  List<String> filteredOperations = <String>[];
  List<String> filteredStates = <String>['Zahájené úkoly', 'Nezahájené úkoly'];
  String selectedSortingFactor = 'Čísla úkolu';
  bool ascendingOrder = true;
  bool areTasksFiltered = false;

  RxList<WorkshopTask> get delayedTasks => displayedTasks
      .where((task) => task.plannedEndDate != null)
      .where((task) => dateUtil.isDateBeforeThisWeek(task.plannedEndDate!))
      .toList()
      .obs;

  RxList<WorkshopTask> get currentWeekTasks => displayedTasks
      .where((task) => task.plannedEndDate != null)
      .where((task) => dateUtil.isDateInThisWeek(task.plannedEndDate!))
      .toList()
      .obs;
  RxList<WorkshopTask> get upcomingTasks => displayedTasks
      .where((task) => task.plannedEndDate != null)
      .where((task) => dateUtil.isDateAfterThisWeek(task.plannedEndDate!))
      .toList()
      .obs;

  Future<void> initializeTasks() async {
    state = TasksLoading().obs;
    (await tasksRepository.getWorkers()).fold(
      (failure) {
        return state = TasksError(failure.message).obs;
      },
      (workers) {
        this.workers = workers;
        getActiveTasks();
      },
    );
  }

  Future<void> getActiveTasks() async {
    (await tasksRepository.getAllActiveTasks()).fold(
      (failure) => state = TasksError(failure.message).obs,
      (tasks) {
        activeTasks.value = tasks;
        activeTasks
            .sort((a, b) => a.plannedEndDate!.compareTo(b.plannedEndDate!));
        getMyTasks();
      },
    );
  }

  Future<void> getMyTasks() async {
    (await tasksRepository.getUsersActiveTasks()).fold(
      (failure) => state = TasksError(failure.message).obs,
      (tasks) async {
        usersTasks.value = tasks;
        await runFilterTasks();
        state = TasksMyTasks().obs;
      },
    );
  }

  Future<void> runFilterTasks() async {
    filteredOperations =
        usersTasks.value.map((e) => e.operation).toSet().toList();
    filterTasks();
  }

  Future<void> refreshTasks() async {
    state = TasksLoading().obs;
    getMyTasks();
  }

  disableFilters() => displayedTasks = usersTasks;

  void filterTasks() async {
    displayedTasks = usersTasks;
    filterOperations();
    filterStates();
    sortTasks();
    state = TasksMyTasks().obs;
    update();
  }

  filterOperations() {
    displayedTasks = displayedTasks
        .where((task) => filteredOperations.contains(task.operation))
        .toList()
        .obs;
  }

  filterStates() {
    var tasksFilteredByStates = <WorkshopTask>[];
    if (filteredStates.contains('Zahájené úkoly')) {
      tasksFilteredByStates
          .addAll(displayedTasks.where((task) => task.startedDate != null));
    }
    if (filteredStates.contains('Nezahájené úkoly')) {
      tasksFilteredByStates
          .addAll(displayedTasks.where((task) => task.startedDate == null));
    }
    displayedTasks = tasksFilteredByStates.obs;
  }

  sortTasks() {
    switch (selectedSortingFactor) {
      case 'Počtu ks':
        displayedTasks.sort((a, b) => ascendingOrder
            ? a.pieces.compareTo(b.pieces)
            : b.pieces.compareTo(a.pieces));
        break;
      case 'Čísla úkolu':
        displayedTasks.sort((a, b) => ascendingOrder
            ? a.taskId.compareTo(b.taskId)
            : b.taskId.compareTo(a.taskId));
        break;
      case 'Pořadí operace':
        displayedTasks.sort((a, b) => ascendingOrder
            ? a.operationOrderNumber.compareTo(b.operationOrderNumber)
            : b.operationOrderNumber.compareTo(a.operationOrderNumber));
        break;
      case 'Plánu \ndokončení':
        // create a sorting algorithm for task.realizedEndDate which is nullable
        displayedTasks.sort((a, b) {
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

  Future<void> finishTask(WorkshopTask? task) async {
    if (task != null) {
      await tasksRepository.finishTask(task);
      refreshTasks();
    }
  }

  Future<void> setTaskToStarted(WorkshopTask? task) async {
    if (task != null) {
      await tasksRepository.setTaskToStarted(task);
      refreshTasks();
    }
  }

  void activateSewingAndPriceTasks(WorkshopTask task) {
    final taskListID = task.taskId;
    // get all tasks with the same taskListID
    final ukolakTasks = tasksRepository.allTasks
        .where((element) => element.taskId == taskListID)
        .toList();
    // make sewing tasks that come first active (901 is the order number of the first sewing task)
    for (var task in ukolakTasks) {
      if (['štep', 'obnitka', 'pevný', 'flatlock'].contains(task.operation) &&
          task.operationOrderNumber == 901) {
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
