import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'administration_logic.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<AdministrationLogic>();
    final state = Get.find<AdministrationLogic>().state;

    return Container();
  }
}
