// lib/controllers/vendor_details_controller.dart

import 'package:get/get.dart';
import '../models/vendor_model.dart';
import '../api/vendor_api.dart';

class VendorDetailsController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<VendorDetail> vendor = Rxn<VendorDetail>();

  @override
  void onInit() {
    super.onInit();
    final String vendorId = Get.arguments as String? ?? "";
    if (vendorId.isNotEmpty) {
      fetchVendor(vendorId);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchVendor(String id) async {
    isLoading.value = true;
    try {
      final data = await VendorApi.fetchVendorById(id);
      vendor.value = data;
    } finally {
      isLoading.value = false;
    }
  }
}
