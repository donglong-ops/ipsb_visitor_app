import 'package:ipsb_visitor_app/src/common/endpoints.dart';
import 'package:ipsb_visitor_app/src/models/shopping_item.dart';

import 'base_service.dart';

mixin IShoppingItemService {
  Future<ShoppingItem?> create(Map<String, dynamic> data);
  Future<bool> delete(int id);
  Future<bool> update(int id, Map<String, dynamic> data);
}

class ShoppingItemService extends BaseService<ShoppingItem>
    with IShoppingItemService {
  @override
  String endpoint() {
    return Endpoints.shoppingItem;
  }

  @override
  ShoppingItem fromJson(Map<String, dynamic> json) {
    return ShoppingItem.fromJson(json);
  }

  @override
  Future<ShoppingItem?> create(Map<String, dynamic> data) {
    return postBase(data);
  }

  @override
  Future<bool> delete(int id) {
    return deleteBase(id);
  }

  @override
  Future<bool> update(int id, Map<String, dynamic> data) {
    return putBase(id, data);
  }
}
