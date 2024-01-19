import 'package:get/get.dart';

import 'administration_logic.dart';

class AdministrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdministrationLogic());
  }
}
