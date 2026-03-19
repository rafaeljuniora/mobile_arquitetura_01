import 'package:flutter/material.dart';
import 'package:publicapi/domain/entities/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 280,
                      minHeight: 220,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: product.image.isEmpty
                            ? const ColoredBox(
                                color: Color(0xFFEFEFEF),
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                  ),
                                ),
                              )
                            : Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const ColoredBox(
                                  color: Color(0xFFEFEFEF),
                                  child: Center(
                                    child: Icon(Icons.broken_image, size: 48),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.attach_money, size: 18),
                  label: Text(product.price.toStringAsFixed(2)),
                ),
                Chip(
                  avatar: const Icon(Icons.category_outlined, size: 18),
                  label: Text(product.category),
                ),
                Chip(
                  avatar: const Icon(Icons.star_border, size: 18),
                  label: Text(
                    '${product.ratingRate.toStringAsFixed(1)} (${product.ratingCount})',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descricao', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar para produtos'),
            ),
          ],
        ),
      ),
    );
  }
}
