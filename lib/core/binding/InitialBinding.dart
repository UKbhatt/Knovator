import 'package:get/get.dart';
import '../../data/services/ApiService.dart';
import '../../data/services/HiveService.dart';
import '../../data/services/ConnectionService.dart';
import '../../data/repositories/PostRepository.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<HiveService>(HiveService(), permanent: true);
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    Get.put<PostRepository>(PostRepository(
      api: Get.find<ApiClient>(),
      hive: Get.find<HiveService>(),
      connectivity: Get.find<ConnectivityService>(),
    ), permanent: true);
  }
}
