import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  // Lista reactiva de items en el carrito
  var items = <CartItem>[].obs;

  void addProduct(Product product) {
    // Verificamos si el producto ya existe en el carrito
    int index = items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      items[index].quantity++;
      items.refresh(); // Notifica a Obx que la lista cambió internamente
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeProduct(String productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int delta) {
    int index = items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      items[index].quantity += delta;

      // Si la cantidad llega a 0 o menos, lo removemos
      if (items[index].quantity <= 0) {
        items.removeAt(index);
      } else {
        items.refresh();
      }
    }
  }

  double get total =>
      items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  void clearCart() {
    items.clear();
  }
}
