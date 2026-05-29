import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_controller.dart';
import '../widgets/app_drawer.dart';

class ComprasScreen extends StatelessWidget {
  const ComprasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PurchaseController controller = Get.put(PurchaseController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Compras"),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const AppDrawer(currentRoute: 'compras'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.purchases.isEmpty) {
          return const Center(
            child: Text("Aún no tienes historial de compras."),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.purchases.length,
          itemBuilder: (context, index) {
            final purchase = controller.purchases[index];
            return Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.receipt_long, color: Colors.blueGrey),
                title: Text(
                  "Pedido: ${purchase.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Lugar: ${purchase.lugar}\nFecha: ${purchase.date.day}/${purchase.date.month}/${purchase.date.year} - \$${purchase.total.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 12),
                ),
                // isThreeLine: true,
                trailing: Chip(
                  label: Text(
                    purchase.status.toUpperCase(),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: purchase.status.toLowerCase() == "completada"
                      ? Colors.green
                      : purchase.status.toLowerCase() == "confirmada"
                      ? Colors.indigo
                      : Colors.orange,
                ),
                children: [
                  ...purchase.items.map((item) {
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          item.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(item.productName),
                      subtitle: Text("Cantidad: ${item.quantity}"),
                      trailing: Text(
                        "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),

                  // Botón de pagar si está pendiente
                  if (purchase.status.toLowerCase() == "pendiente")
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showPaymentMethodSelector(
                            context,
                            controller,
                            purchase.id,
                          ),
                          icon: const Icon(Icons.payment),
                          label: const Text("Pagar ahora"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showPaymentMethodSelector(
    BuildContext context,
    PurchaseController controller,
    String purchaseId,
  ) async {
    // Cargar métodos antes de mostrar el modal
    await controller.loadPaymentMethods();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selecciona un método de pago",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.paymentMethods.isEmpty) {
                return const Center(child: Text("Cargando métodos..."));
              }
              return Column(
                children: controller.paymentMethods.map((method) {
                  return ListTile(
                    leading: Icon(
                      method['metodo'].toString().contains('Tarjeta')
                          ? Icons.credit_card
                          : Icons.money,
                      color: Colors.blueGrey,
                    ),
                    title: Text(method['metodo']),
                    onTap: () {
                      Get.back(); // Cerrar modal
                      _confirmPayment(
                        purchaseId,
                        method['id'],
                        method['metodo'],
                        controller,
                      );
                    },
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _confirmPayment(
    String purchaseId,
    int methodId,
    String methodName,
    PurchaseController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmar Pago"),
        content: Text(
          "¿Deseas pagar el pedido #$purchaseId usando $methodName?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.pay(purchaseId, methodId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }
}
