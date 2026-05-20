import 'package:get/get.dart';
import '../models/purchase_model.dart';
import '../api/purchase_api.dart';

class PurchaseController extends GetxController {
  final RxList<Purchase> purchases = <Purchase>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    isLoading.value = true;
    try {
      final data = await PurchaseApi.fetchPurchases();
      purchases.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }
}
