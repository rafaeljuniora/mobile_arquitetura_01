import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publicapi/providers/product_favorites_provider.dart';

class ProductFavoritesActivityScreen extends StatefulWidget {
  const ProductFavoritesActivityScreen({super.key});

  @override
  State<ProductFavoritesActivityScreen> createState() =>
      _ProductFavoritesActivityScreenState();
}

class _ProductFavoritesActivityScreenState
    extends State<ProductFavoritesActivityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductFavoritesProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atividade: Favoritos (Provider)')),
      body: Consumer<ProductFavoritesProvider>(
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.error!),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: state.loadProducts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final products = state.products;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Favoritos: ${state.favoriteCount}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    FilterChip(
                      selected: state.showOnlyFavorites,
                      label: const Text('Somente favoritos'),
                      onSelected: (_) => state.toggleFavoritesFilter(),
                    ),
                  ],
                ),
              ),
              if (products.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      state.showOnlyFavorites
                          ? 'Nenhum favorito selecionado.'
                          : 'Nenhum produto encontrado.',
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: state.loadProducts,
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isFavorite = product.favorite;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          color: isFavorite
                              ? Theme.of(context).colorScheme.secondaryContainer
                                    .withValues(alpha: 0.45)
                              : null,
                          child: ListTile(
                            title: Text(product.title),
                            subtitle: Text(
                              'R\$ ${product.price.toStringAsFixed(2)}',
                            ),
                            trailing: IconButton(
                              onPressed: () => state.toggleFavorite(product),
                              tooltip: isFavorite
                                  ? 'Remover dos favoritos'
                                  : 'Marcar como favorito',
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite
                                    ? Colors.amber[700]
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
