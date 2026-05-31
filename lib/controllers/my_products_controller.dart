import 'dart:io';

import 'package:app_lince_emp/components/modal_card.dart';
import 'package:app_lince_emp/core/desings/themes.dart';
import 'package:app_lince_emp/core/utils/Text_extension.dart';
import 'package:app_lince_emp/models/categoria_model.dart';
import 'package:app_lince_emp/widgets/flex_box.dart';
import 'package:app_lince_emp/widgets/input_select.dart';
import 'package:app_lince_emp/widgets/input_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../api/product_api.dart';
import '../models/product_model.dart';
import 'auth_controller.dart';

class MyProductsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final RxBool isLoading = false.obs;
  final RxList<Product> myProducts = <Product>[].obs;
  final RxList<Categoria> allCategories = <Categoria>[].obs;
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final stockController = TextEditingController();
  List<Map<String, dynamic>> _categorias = [];

  final List<Map<String, dynamic>> _estados = [
    {'id': '1', 'nombre': 'disponible'},
    {'id': '2', 'nombre': 'agotado'},
    {'id': '3', 'nombre': 'pausado'},
    //disponible,agotado,pausado
  ];

  final ImagePicker picker = ImagePicker();
  final RxList<XFile> imagenes = <XFile>[].obs;

  RxBool esPerecedero = true.obs;
  String? _categoriaId, _estadosId = '1';

  @override
  void onInit() {
    super.onInit();
    _loadCategorias();
    fetchMyProducts();
  }

  Future<void> fetchMyProducts() async
  {
    final token = authController.token.value;
    if (token == null) return;

    isLoading.value = true;
    try {
      final products = await ProductApi.fetchMyProducts(token);
      myProducts.assignAll(products);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCategorias() async {
    try {
      isLoading.value = true;
      final categorias = await ProductApi.fetchAllCategory();
      categorias.forEach((categoria) {
        _categorias.add({
          'id': categoria.id.toString(),
          'nombre': categoria.name,
        });
      });
    } catch (e) {
      Get.snackbar("Error", "No se pudo conectar con el servidor.");
    } finally {
      isLoading.value = false;
    }
  }

  void createdProduct(context) {
    limpiarFormulario();
    showDialog(
      context: context,
      builder: (context) => _buildModalForm(context, () {
        final token = authController.token.value;
        if (token == null) {
          Get.snackbar("Inicia sesión", "Necesitas estar autenticado");
          return;
        }
        ;
        try {
          ProductApi.storeProducto(
            token: token,
            nombre: nombreController.text,
            descripcion: descripcionController.text,
            precio: double.parse(precioController.text),
            stock: int.parse(stockController.text),
            es_perecedero: esPerecedero.value,
            status: _estados.firstWhere(
              (estado) => estado['id'] == _estadosId,
            )['nombre'],
            categorias: _categoriaId != null
                ? [int.parse(_categoriaId!)]
                : null,
            imagenes: imagenes,
          );
          Get.snackbar("Producto creado con éxito", "El producto ha sido creado con éxito");
          Navigator.pop(context);
        } catch (e) {
          Get.snackbar("Ocurrio un error", "Erro: ${e}");
        }
      }),
    );
  }

  // Placeholders para funcionalidades futuras
  void editProduct(context, Product product) {
    limpiarFormulario();
    llenarFormulario(product);
     showDialog(
      context: context,
      builder: (context) => _buildModalForm(context, ()
      {
        final token = authController.token.value;
        if (token == null) {
          Get.snackbar("Inicia sesión", "Necesitas estar autenticado");
          return;
        }
        ;
        try {
          ProductApi.updateProducto(
            token: token,
            id: product.id,
            nombre: nombreController.text,
            descripcion: descripcionController.text,
            precio: double.parse(precioController.text),
            stock: int.parse(stockController.text),
            es_perecedero: esPerecedero.value,
            status: _estados.firstWhere(
              (estado) => estado['id'] == _estadosId,
            )['nombre'],
            categorias: _categoriaId != null
                ? [int.parse(_categoriaId!)]
                : null,
            imagenes: imagenes,
          );
          Navigator.pop(context);
        } catch (e) {
          Get.snackbar("Ocurrio un error", "Erro: ${e}");
        }
      }),
    );
  }

  void deleteProduct(Product product) {
    Get.defaultDialog(
      title: "Eliminar Producto",
      middleText: "¿Estás seguro de que deseas eliminar ${product.name}?",
      onConfirm: () async {
        try {
          final token = authController.token.value;
          if (token == null) return;
          Get.back();
          if(await ProductApi.deleteProducto(product.id, token))
          {
            Get.snackbar('Éxito', 'Producto eliminado correctamente');
          }
          else{
            Get.snackbar('No se pudo eliminar el producto', 'El producto tiene ventas registradas');
          };
        } catch (e) {
          Get.snackbar('Error', 'No se pudo eliminar el producto');
        }
      },
      textConfirm: "Eliminar",
      confirmTextColor: Colors.white,
    );
  }

  void addProduct() {
    Get.snackbar("Nuevo Producto", "Próximamente: Formulario de creación");
  }

  Future<void> seleccionarImagenes() async {
    final List<XFile> files = await picker.pickMultiImage();

    if (files.isNotEmpty) {
      imagenes.value = files;
    }
  }

  void limpiarFormulario() {
    nombreController.clear();
    descripcionController.clear();
    precioController.clear();
    stockController.clear();

    imagenes.clear();

    esPerecedero.value = true;

    _categoriaId = null;
    _estadosId = '1';
  }

  void llenarFormulario(Product product) {
    nombreController.text = product.name;
    descripcionController.text = product.description;
    precioController.text = product.price.toString();
    stockController.text = product.stock.toString();
    _categoriaId = product.categoria[0].id;
    _estadosId = _estados.firstWhere(
      (estado) => estado['nombre'] == product.status,
    )['id'];
  }

  Widget buildImagePicker() {
    return Obx(() {
      return InkWell(
        borderRadius: BorderRadius.circular(15),

        onTap: seleccionarImagenes,

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: Colors.grey.shade100,

            borderRadius: BorderRadius.circular(15),

            border: Border.all(
              color: Colors.grey.shade400,
              style: BorderStyle.solid,
            ),
          ),

          child: imagenes.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 50,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Agregar imágenes del producto",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Haz clic para seleccionar imágenes",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          "${imagenes.length} imágenes seleccionadas",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        IconButton(
                          onPressed: () {
                            imagenes.clear();
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,

                      children: imagenes.map((img) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),

                              child: kIsWeb
                                  ? Image.network(
                                      img.path,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(img.path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),

                            Positioned(
                              top: 5,
                              right: 5,

                              child: GestureDetector(
                                onTap: () {
                                  imagenes.remove(img);
                                },

                                child: Container(
                                  padding: const EdgeInsets.all(4),

                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Widget _buildModalForm(context, VoidCallback onTap) {
    double width = MediaQuery.of(context).size.width;
    String titulo = "Crear Producto";
    return Modalcard(
      title: titulo,
      childrenBody: [
        buildImagePicker(),
        Inputtext(
          Label: 'Nombre:',
          Placeholder: 'Ingrese el nombre de la imagen',
          controller: nombreController,
        ),
        Inputtext(
          Label: 'Descripción:',
          Placeholder: 'Ingrese una descripción',
          controller: descripcionController,
        ),
        FlexBox(
          expanded: true,
          flexDirection: 'row',
          gap: 10,
          children: [
            Expanded(
              child: Inputtext(
                Label: 'Precio',
                Placeholder: 'Ingrese el precio',
                controller: precioController,
              ),
            ),
            Expanded(
              child: Inputtext(
                Label: 'Stock',
                Placeholder: 'Ingrese la cantidad',
                controller: stockController,
              ),
            ),
          ],
        ),
        _buildInputCategoria(width),
        Obx(
          () => FlexBox(
            marginTop: 10,
            gap: 5,
            flexDirection: 'row',
            verticalAlignment: 'center',
            children: [
              Switch(
                value: esPerecedero.value,
                onChanged: (value) {
                  esPerecedero.value = value;
                },
              ),
              Text('Es perecedero.').styled(cardLabel),
            ],
          ),
        ),
      ],
      onTapAceptar: onTap,
    );
  }

  Widget _buildInputCategoria(double width) {
    if (width < 600) {
      return FlexBox(
        gap: 10,
        children: [
          InputSelect(
            value: _categoriaId,
            label: 'Categoria:',
            placeholder: width < 600 ? 'Categoría' : 'Seleccione la categoría',
            options: _categorias, // Usamos la lista que viene del builder
            onChanged: (value) {
              _categoriaId = value.toString();
            },
          ),
          InputSelect(
            value: _estadosId,
            label: 'Estado:',
            placeholder: 'Selecciona el estatus del producto.',
            options: _estados, // Usamos la lista que viene del builder
            onChanged: (value) {
              _estadosId = value.toString();
            },
          ),
        ],
      );
    }
    return FlexBox(
      expanded: true,
      flexDirection: 'row',
      gap: 5,
      children: [
        Expanded(
          child: InputSelect(
            value: _categoriaId,
            label: 'Categoria:',
            placeholder: width < 600 ? 'Categoría' : 'Seleccione la categoría',
            options: _categorias, // Usamos la lista que viene del builder
            onChanged: (value) {
              _categoriaId = value.toString();
            },
          ),
        ),
        Expanded(
          child: InputSelect(
            value: _estadosId,
            label: 'Estado:',
            placeholder: 'Selecciona el estatus del producto.',
            options: _estados, // Usamos la lista que viene del builder
            onChanged: (value) {
              _estadosId = value.toString();
            },
          ),
        ),
      ],
    );
  }
}
