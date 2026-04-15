import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publicapi/models/product.dart';
import 'package:publicapi/providers/product_favorites_provider.dart';
import 'package:publicapi/screens/product_detail_screen.dart';
import 'package:publicapi/screens/product_favorites_activity_screen.dart';
import 'package:publicapi/screens/product_form_screen.dart';
import 'package:publicapi/services/product_service.dart';
import 'package:publicapi/widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final bool autoLoad;

  const ProductListScreen({super.key, this.autoLoad = true});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _service = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = widget.autoLoad
        ? _service.fetchProducts()
        : Future.value(<Product>[]);
  }

  void _reload() {
    setState(() {
      _productsFuture = _service.fetchProducts();
    });
  }

  Future<void> _openForm({Product? product}) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProductFormScreen(product: product)),
    );

    if (changed == true) {
      _reload();
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja excluir "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirm != true) return;
    if (product.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto sem id nao pode ser excluido.')),
      );
      return;
    }

    try {
      await _service.deleteProduct('${product.id}');
      if (!mounted) return;
      _reload();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto excluido com sucesso.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao excluir produto.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        actions: [
          IconButton(
            tooltip: 'Atividade favoritos',
            icon: const Icon(Icons.star_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => ProductFavoritesProvider(ProductService()),
                    child: const ProductFavoritesActivityScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Erro ao carregar produtos.'),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _reload,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data ?? <Product>[];
          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  onEdit: () => _openForm(product: product),
                  onDelete: () => _deleteProduct(product),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}
