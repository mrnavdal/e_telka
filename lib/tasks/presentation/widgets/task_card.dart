import 'package:e_telka/tasks/presentation/pages/task_detail_page.dart';
import 'package:e_telka/tasks/presentation/tasks_controller.dart';
import 'package:e_telka/tasks/presentation/widgets/task_detail.dart';
import 'package:e_telka/tasks/presentation/widgets/tasks_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../domain/entities/task.dart';

class TaskCard extends StatefulWidget {
  Task task;
  TaskCard(this.task, {super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final logic = Get.find<TasksController>();

  void showToast(String message, Color backgroundColor, Color textColor) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TaskDetailPage(widget.task), transition: Transition.rightToLeft);
      },
      child: Card(
        child: ListTile(
          title: Text('${widget.task.taskId}: ${widget.task.operation}'),
          subtitle: Text('Kreditů: ${widget.task.creditPriceTotalAmount}'),
          trailing: _buildTaskActionButton(context, widget.task),
        ),
      ),
    );
  }

  Widget _buildTaskActionButton(BuildContext context, Task task) {
    if (task.startedDate == null) {
      return TaskNotStartedButton(task);
    } else if (task.realizedEndDate == null) {
      return TaskStartedButton(task);
    }
    return TaskFinishedButton();
  }

  Widget TaskNotStartedButton(Task task) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      onPressed: () {
        setState(() {
          showConfirmationDialog(context, 'Začít úkol',
                  'Jste si jisti, že chcete začít úkol? Tato akce nelze vzít zpět.')
              .then((value) {
            if (value == true) {
              logic.setTaskToStarted(task);
              showToast('Úkol byl započat.', Colors.yellow, Colors.white);
            }
          });
        });
      },
      child: Text(
        'Začít',
        style:
            TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }

  Widget TaskStartedButton(Task task) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      onPressed: () {
        setState(() {
          showConfirmationDialog(context, 'Dokončit úkol',
                  'Jste si jisti, že chcete dokončit úkol? Tato akce nelze vzít zpět.')
              .then((value) {
            if (value == true) {
              setState(() {
                logic.finishTask(widget.task);
                handleSpecialCases(widget.task);
                showToast(
                    'Výborně! Úkol byl dokončen.', Colors.green, Colors.white);
              });
            }
          });
        });
      },
      child: Text(
        'Dokončit',
        style:
            TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
      ),
    );
  }

  Widget TaskFinishedButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Úkol dokončen'),
    );
  }

  /// Checkuje speciální případy, kdy je potřeba upravit další úkoly
  /// Jedná se o případy tyto případy
  /// - Když uživatel potvrzuje dokončení operace rezervace materiálu, doptat se ho, jestli je na tento úkolák dost materiálu na skladě) Ano / Ne).
  /// -- pokud ne, je následující krok objednávka materiálu
  /// -- pokud ano, krok objednávka materiálu se přeskakuje a jde to rovnou na úkol nastříhání.
  /// - Když uživatel potvrzuje dokončení operace nastříhání, doptat se ho, jestli může dílna začít šicí práce Ano / ne.
  /// -- pokud ne - aktivní úkol se stane pouze úkol výdejka
  /// -- pokud ano - kromě výdejky se aktivní úkoly stanou ještě úkoly následující po úkolu výdejka.
  void handleSpecialCases(Task task) {
    if (task.operation == 'rezervace materiálu') {
      showConfirmationDialog(
              context, 'Dostatek materiálu', 'Je na skladě dostatek materiálu?')
          .then((value) {
        if (value == true) {
          final objednavkaMaterialuTask = logic.getFollowingTask(task);
          logic.setTaskToStarted(objednavkaMaterialuTask);
          logic.finishTask(objednavkaMaterialuTask);
        }
      });
    }
    if (task.operation == 'nastříhání') {
      showConfirmationDialog(context, 'Šicí práce', 'Mohou začít šicí práce?')
          .then((value) {
        if (value == true) {
          logic.activateSewingAndPriceTasks(task);
        }
      });
    }
  }
}
