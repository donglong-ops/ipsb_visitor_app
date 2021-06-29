import 'package:indoor_positioning_visitor/src/common/endpoints.dart';
import 'package:indoor_positioning_visitor/src/models/paging.dart';
import 'package:indoor_positioning_visitor/src/models/store.dart';
import 'package:indoor_positioning_visitor/src/services/api/base_service.dart';

mixin IStoreService {
  Future<Store> getStoreById(int id);
  Future<Paging<Store>> getStores(String searchName, int floorPlanId);
  Future<Paging<Store>> getStoresByBuilding(int buildingId);
}

class StoreService extends BaseService<Store> implements IStoreService {
  @override
  String endpoint() {
    return Endpoints.stores;
  }

  @override
  Store fromJson(Map<String, dynamic> json) {
    return Store.fromJson(json);
  }

  @override
  Future<Store> getStoreById(int id) {
    return getByIdBase(id);
  }

  Future<Paging<Store>> getStores(String searchName, int floorPlanId) async {
    return getPagingBase({
      "name": searchName.toString(),
      "floorPlanId": floorPlanId.toString(),
    });
  }

  @override
  Future<Paging<Store>> getStoresByBuilding(int buildingId) {
    return getPagingBase({
      "buildingId": buildingId.toString(),
    });
  }
}
