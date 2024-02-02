import 'package:e_telka/core/data/data_sources/core_data_source.dart';
import 'package:e_telka/core/data/data_sources/core_data_source_impl.dart';
import 'package:e_telka/core/util/date_util.dart';
import 'package:e_telka/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:e_telka/tasks/data/datasources/tasks_remote_data_source_impl.dart';
import 'package:e_telka/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:e_telka/tasks/domain/repositories/tasks_repository.dart';
import 'package:e_telka/tasks/presentation/tasks_controller.dart';
import 'package:get/instance_manager.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksController());
    Get.lazyPut<TasksRepository>(() => TasksRepositoryImpl());
    Get.lazyPut<TasksRemoteDataSource>(() => TasksRemoteDataSourceImpl());
    Get.lazyPut<CoreRemoteDataSource>(() => CoreRemoteDataSourceImpl());
    Get.lazyPut(() => DateUtil());
  }
}