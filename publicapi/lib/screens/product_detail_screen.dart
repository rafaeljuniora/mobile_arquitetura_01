import 'package:flutter/material.dart';
import 'package:publicapi/models/product.dart';
import 'package:publicapi/services/product_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product? product;
  final int? productId;
  final ProductService _service = ProductService();

  ProductDetailScreen({super.key, this.product, this.productId})
      : assert(product != null || productId != null,
            'Either product or productId must be provided');

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      return _buildDetail(context, product!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: FutureBuilder<Product>(
        future: _service.getProductById(productId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final prod = snapshot.data;
          return prod != null
              ? _buildDetail(context, prod)
              : const Center(child: Text('Produto nao encontrado'));
        },
      ),
    );
  }

  Widget _buildDetail(BuildContext context, Product product) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: product.image.isEmpty
                        ? const ColoredBox(
                            color: Color(0xFFEFEFEF),
                            child:
                                Icon(Icons.image_not_supported, size: 48),
                          )
                        : Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const ColoredBox(
                              color: Color(0xFFEFEFEF),
                              child:
                                  Icon(Icons.broken_image, size: 48),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Preco: R\$ ${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Categoria: ${product.category}'),
            const SizedBox(height: 16),
            Text('Descricao', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
