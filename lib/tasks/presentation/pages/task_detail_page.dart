import 'package:e_telka/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  const TaskDetailPage(this.task, {super.key});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return GestureDetector(
      onHorizontalDragEnd: (dragDetail) {
        setState(() {
          if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
            _selectedIndex = 1;
          } else {
            _selectedIndex = 0;
          }
        });
      },
      child: Scaffold(
        // BottomAppbar that toggles between  two states
        bottomNavigationBar: BottomAppBar(
          color: colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: _selectedIndex == 0
                    ? TextButton.styleFrom(
                    backgroundColor: colorScheme.inversePrimary)
                    : null,
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.task, color: Colors.black),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text('Úkol', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: _selectedIndex == 1
                    ? TextButton.styleFrom(
                        backgroundColor: colorScheme.inversePrimary)
                    : null,
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.checkroom, color: Colors.black),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Produkt',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: colorScheme.inversePrimary,
          title: Text('Detail úkolu: ${task.taskId}'),
        ),
        body: _selectedIndex == 0 ? OperationsInfo() : ProductInfo(),
      ),
    );
  }

  Widget OperationsInfo() {
    final task = widget.task;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          InfoListTile('Operace', task.operation),
          InfoListTile('Úkolák', task.spreadsheetSource),
          InfoListTile('Kusů', task.formattedPieces),
          InfoListTile('Kreditů celkem za úkol', task.formattedCreditsTotal),
          InfoListTile('Kreditů za jednotku', task.formattedCreditsUnit),
          InfoListTile(
              'Plánované datum dokončení', task.formattedPlannedEndDate),
        ],
      ).animate(effects: [
        const SlideEffect(
            begin: Offset(-1, 0),
            end: Offset(0, 0),
            duration: Duration(milliseconds: 75))
      ]),
    );
  }

  Widget InfoListTile(String title, String value) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ListTile(
      title: Text(title, style: textTheme.titleMedium),
      trailing: Text(value, style: textTheme.titleMedium),
    );
  }

  Widget ProductInfo() {
    final task = widget.task;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          InfoListTile('Číslo produktu', task.productId),
          InfoListTile('Jméno produktu', task.productName),
          InfoListTile('Kategorie materiálu', task.productMaterialGroupCategory),
          InfoListTile('Materiál', task.productMaterialCategory),
        ],
      ),
    ).animate(effects: [
      const SlideEffect(
          begin: Offset(1, 0),
          end: Offset(0, 0),
          duration: Duration(milliseconds: 75))
    ]);
  }
}
