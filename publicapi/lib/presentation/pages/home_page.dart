import 'package:flutter/material.dart';
import 'package:publicapi/presentation/pages/product_page.dart';
import 'package:publicapi/presentation/viewmodels/product_viewmodel.dart';

class HomePage extends StatelessWidget {
  final ProductViewModel viewModel;

  const HomePage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Public API Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bem-vindo!\nAcesse a lista de produtos da Fake API.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  viewModel.loadProducts();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductPage(viewModel: viewModel),
                    ),
                  );
                },
                icon: const Icon(Icons.storefront),
                label: const Text('Ver Produtos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
