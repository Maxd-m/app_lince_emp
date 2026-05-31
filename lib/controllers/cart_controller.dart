import 'package:app_lince_emp/screens/mercado_pago_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../api/purchase_api.dart';

class CartController extends GetxController {
  // Lista reactiva de items en el carrito
  var items = <CartItem>[].obs;
  var isLoading = false.obs;

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

  // Future<void> checkout({
  //   required String lugar,
  //   required String tipo,
  //   int? idMetodoPago,
  // }) async {
  //   if (items.isEmpty) return;

  //   isLoading.value = true;
  //   try {
  //     final List<Map<String, dynamic>> productos = items.map((item) {
  //       return {
  //         'id_producto': int.parse(item.product.id),
  //         'cantidad': item.quantity,
  //       };
  //     }).toList();

  //     final success = await PurchaseApi.createPurchase(
  //       lugar: lugar,
  //       tipo: tipo,
  //       productos: productos,
  //       id_metodo_de_pago: idMetodoPago,
  //     );

  //     if (success) {
  //       clearCart();
  //       Get.back(); // Cierra el modal de opciones de pago
  //       Get.snackbar(
  //         "Éxito",
  //         "Venta creada correctamente.",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );
  //     } else {
  //       Get.snackbar("Error", "No se pudo procesar la venta");
  //     }
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> checkout({
    required String lugar,
    required String tipo,
    int? idMetodoPago,
  }) async {
    if (items.isEmpty) return;

    isLoading.value = true;
    try {
      final List<Map<String, dynamic>> productos = items.map((item) {
        return {
          'id_producto': int.parse(item.product.id),
          'cantidad': item.quantity,
        };
      }).toList();

      // Clonamos la lógica de React: si es Tarjeta (id 2), el tipo enviado es "confirmada"
      final String tipoFinal = (idMetodoPago == 2) ? "confirmada" : tipo;

      final responseData = await PurchaseApi.createPurchase(
        lugar: lugar.isEmpty ? "UTICS" : lugar,
        tipo: tipoFinal,
        productos: productos,
        id_metodo_de_pago: tipo == "pagada" ? idMetodoPago : null,
      );

      if (responseData != null) {
        // 1. Clonar envío de mensajes automáticos a vendedores
        // Nota: Asegúrate de adaptar 'item.product.vendorId' según tu modelo real

        // 2. Extraer datos de la transacción (Mercado Pago)
        // Estructura esperada según tu TS: response.data['data']['transaccion']['preference_id']
        // Ajusta los índices según cómo devuelva tu backend el JSON en la key 'data'
        print(
          "🔍 [DEBUG MP] JSON completo recibido en el controlador: $responseData",
        );
        final backendData = responseData['data'] ?? responseData;
        final transaccion = backendData['transaccion'];

        print("🔍 [DEBUG MP] Objeto 'transaccion' extraído: $transaccion");

        final String? preferenceId = transaccion != null
            ? transaccion['preference_id']
            : null;

        print("🔍 [DEBUG MP] Preference ID final: '$preferenceId'");

        if (idMetodoPago == 2 && preferenceId != null) {
          Get.back(); // Cierra el bottom sheet actual

          // 3. Redirigir a Mercado Pago
          _abrirMercadoPago(preferenceId);
        } else {
          // Flujo estándar (Efectivo / Pendiente)
          clearCart();
          Get.back();
          Get.snackbar(
            "Éxito",
            "Pedido realizado con éxito!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar("Error", "No se pudo procesar la venta");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _abrirMercadoPago(String preferenceId) {
    bool esModoPruebas = true;

    String urlMercadoPago;

    if (esModoPruebas) {
      // URL Oficial de redirección para el entorno de pruebas (Sandbox) en México
      urlMercadoPago =
          "https://sandbox.mercadopago.com.mx/checkout/v1/redirect?pref_id=$preferenceId";
    } else {
      // URL Oficial de redirección para producción en México
      urlMercadoPago =
          "https://www.mercadopago.com.mx/checkout/v1/redirect?pref_id=$preferenceId";
    }

    // 🔍 PRINT 4: Ver la URL exacta que cargará el WebView
    print("🌍 [DEBUG MP] Abriendo WebView con la URL: $urlMercadoPago");

    Get.to(() => MercadoPagoWebViewScreen(url: urlMercadoPago));
    // Por ahora limpiaremos el carrito asumiendo que va a pagar
    clearCart();
  }
}
