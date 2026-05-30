import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MercadoPagoWebViewScreen extends StatefulWidget {
  final String url;
  const MercadoPagoWebViewScreen({Key? key, required this.url})
    : super(key: key);

  @override
  State<MercadoPagoWebViewScreen> createState() =>
      _MercadoPagoWebViewScreenState();
}

class _MercadoPagoWebViewScreenState extends State<MercadoPagoWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);

            // Si tu backend tiene URLs de retorno (success, failure, pending),
            // puedes interceptarlas aquí para saber cuándo el usuario terminó de pagar:
            if (url.contains('tu-url-de-exito.com') ||
                url.contains('approved')) {
              Get.back();
              Get.snackbar(
                "Pago Exitoso",
                "¡Gracias por tu compra!",
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagar con Mercado Pago"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
