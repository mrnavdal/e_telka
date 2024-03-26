import 'package:e_telka/tasks/domain/entities/workshop_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class TaskDetailPage extends StatefulWidget {
  final WorkshopTask task;
  const TaskDetailPage(this.task, {super.key});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (dragDetail) => updateIndexOnDrag(dragDetail),
      child: Scaffold(
        bottomNavigationBar: buildBottomAppBar(),
        appBar: buildAppBar(),
        body: _selectedIndex == 0 ? operationsInfo() : productInfo(),
      ),
    );
  }

  void updateIndexOnDrag(DragEndDetails dragDetail) {
    setState(() {
      _selectedIndex = dragDetail.velocity.pixelsPerSecond.dx < 1 ? 1 : 0;
    });
  }

  BottomAppBar buildBottomAppBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return BottomAppBar(
      color: colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildBottomNavigationButton(0, Icons.task, 'Úkol'),
          buildBottomNavigationButton(1, Icons.checkroom, 'Produkt'),
        ],
      ),
    );
  }

  TextButton buildBottomNavigationButton(
      int index, IconData icon, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextButton(
      style: _selectedIndex == index
          ? TextButton.styleFrom(backgroundColor: colorScheme.inversePrimary)
          : null,
      onPressed: () => updateIndex(index),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(text, style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar buildAppBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final task = widget.task;
    return AppBar(
      backgroundColor: colorScheme.inversePrimary,
      title: Text('Detail úkolu: ${task.taskId}'),
    );
  }

  Widget operationsInfo() {
    final task = widget.task;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          infoListTile('Operace', task.operation),
          infoListTile('Úkolák', task.spreadsheetSource),
          infoListTile('Kusů', task.formattedPieces),
          infoListTile('Kreditů celkem za úkol', task.formattedCreditsTotal),
          infoListTile('Kreditů za jednotku', task.formattedCreditsUnit),
          infoListTile(
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

  Widget infoListTile(String title, String value) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ListTile(
      title: Text(title, style: textTheme.titleMedium),
      trailing: Text(value, style: textTheme.titleMedium),
    );
  }

  Widget productInfo() {
    final task = widget.task;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          infoListTile('Číslo produktu', task.productId),
          infoListTile('Jméno produktu', task.productName),
          infoListTile(
              'Kategorie materiálu', task.productMaterialGroupCategory),
          infoListTile('Materiál', task.productMaterialCategory),
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
