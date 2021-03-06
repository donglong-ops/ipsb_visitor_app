import 'package:ipsb_visitor_app/src/common/endpoints.dart';
import 'package:ipsb_visitor_app/src/models/building.dart';
import 'package:ipsb_visitor_app/src/services/api/base_service.dart';

mixin IBuildingService {
  Future<Building?> getBuildingById(int id);
  Future<List<Building>> getBuildings();
  Future<List<Building>> searchBuildings([String? search]);
}

class BuildingService extends BaseService<Building>
    implements IBuildingService {
  @override
  String endpoint() {
    return Endpoints.buildings;
  }

  @override
  Building fromJson(Map<String, dynamic> json) {
    return Building.fromJson(json);
  }

  @override
  Future<Building?> getBuildingById(int id) async {
    return getByIdBase(id);
  }

  @override
  Future<List<Building>> getBuildings() {
    return getAllBase({"pageSize": "5"});
  }

  @override
  Future<List<Building>> searchBuildings([String? search]) {
    final params = {
      "pageSize": "5",
      "status": "Active",
    };
    if (search != null) {
      params.putIfAbsent("name", () => search);
      params.putIfAbsent("isAll", () => "true");
    }
    return getAllBase(params);
  }
}
