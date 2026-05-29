// lib/screens/ventas_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/venta_controller.dart';
import '../widgets/app_drawer.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VentaController controller = Get.put(VentaController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Ventas (Vendedor)"),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const AppDrawer(currentRoute: 'ventas'),
      body: Obx(() {
        if (controller.isLoading.value && controller.ventas.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.ventas.isEmpty) {
          return const Center(child: Text("No tienes ventas registradas."));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchVentas,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.ventas.length,
            itemBuilder: (context, index) {
              final venta = controller.ventas[index];
              final cliente = venta['cliente'] ?? {};
              final detalles = venta['detalles'] as List<dynamic>? ?? [];
              final status = (venta['status'] as String).toLowerCase();
              final total = venta['transaccion']?['total'] ?? "0.00";

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.sell, color: Colors.blueGrey),
                  title: Text(
                    "Venta #${venta['id']} - $total",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Cliente: ${cliente['nombre']}\nLugar: ${venta['lugar']}",
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: status == "confirmada"
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    ...detalles.map((d) {
                      final producto = d['producto'] ?? {};
                      return ListTile(
                        title: Text(producto['nombre'] ?? "Producto"),
                        subtitle: Text("Cantidad: ${d['cantidad']}"),
                        trailing: Text("\$${d['precio_unitario']}"),
                      );
                    }).toList(),

                    if (status == "confirmada")
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _confirmarCompletar(venta['id'], controller),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text("Completar Entrega"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _confirmarCompletar(int id, VentaController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("¿Completar venta?"),
        content: const Text(
          "Asegúrate de que el cliente haya recibido sus productos.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.completarVenta(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }
}
