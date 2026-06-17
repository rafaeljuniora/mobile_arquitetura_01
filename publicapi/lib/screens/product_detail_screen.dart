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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildImageHeader(context, product),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (product.category.isNotEmpty)
                      Chip(
                        avatar: Icon(
                          Icons.category_outlined,
                          size: 18,
                          color: colorScheme.onSecondaryContainer,
                        ),
                        label: Text(product.category),
                        backgroundColor: colorScheme.secondaryContainer,
                        labelStyle: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                        ),
                        side: BorderSide.none,
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 24),
                Text(
                  'Descrição',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description.isEmpty
                      ? 'Sem descrição disponível.'
                      : product.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context, Product product) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 320,
      color: colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: product.image.isEmpty
          ? Icon(
              Icons.image_not_supported_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            )
          : Image.network(
              product.image,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) => Icon(
                Icons.broken_image_outlined,
                size: 64,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
    );
  }
}
