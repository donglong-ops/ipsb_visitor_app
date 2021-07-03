import 'package:image_picker/image_picker.dart';
import 'package:indoor_positioning_visitor/src/common/endpoints.dart';
import 'package:indoor_positioning_visitor/src/models/coupon.dart';
import 'package:indoor_positioning_visitor/src/models/paging.dart';
import 'package:indoor_positioning_visitor/src/services/api/base_service.dart';

mixin ICouponService {
  Future<List<Coupon>> getCouponsByStoreId(int storeId);
  Future<Paging<Coupon>> getCoupons();
}

class CouponService extends BaseService<Coupon> implements ICouponService {
  @override
  String endpoint() {
    return Endpoints.coupons;
  }

  @override
  Coupon fromJson(Map<String, dynamic> json) {
    return Coupon.fromJson(json);
  }

  @override
  Future<List<Coupon>> getCouponsByStoreId(int storeId) {
    return getAllBase(
      {
        'storeId': storeId.toString(),
      },
    );
  }

  @override
  Future<Paging<Coupon>> getCoupons() async {
    return getPagingBase({});
  }
}
