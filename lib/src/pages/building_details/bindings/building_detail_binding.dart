import 'package:get/get.dart';
import 'package:ipsb_visitor_app/src/pages/building_details/controllers/building_detail_controller.dart';

class BuildingDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Bind Building Details controller
    Get.lazyPut<BuildingDetailController>(() => BuildingDetailController());
  }
}
