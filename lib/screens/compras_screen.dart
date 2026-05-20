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
                  "Fecha: ${purchase.date.day}/${purchase.date.month}/${purchase.date.year} - \$${purchase.total.toStringAsFixed(2)}",
                ),
                trailing: Chip(
                  label: Text(
                    purchase.status,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: purchase.status == "Entregado"
                      ? Colors.green
                      : Colors.orange,
                ),
                children: purchase.items.map((item) {
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
              ),
            );
          },
        );
      }),
    );
  }
}
