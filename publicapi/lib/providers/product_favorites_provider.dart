import 'package:flutter/foundation.dart';
import 'package:publicapi/models/product.dart';
import 'package:publicapi/services/product_service.dart';

class ProductFavoritesProvider extends ChangeNotifier {
  final ProductService _service;

  ProductFavoritesProvider(this._service);

  final List<Product> _products = <Product>[];
  bool _isLoading = false;
  bool _showOnlyFavorites = false;
  String? _error;

  bool get isLoading => _isLoading;
  bool get showOnlyFavorites => _showOnlyFavorites;
  String? get error => _error;

  int get favoriteCount => _products.where((p) => p.favorite).length;

  List<Product> get products {
    if (!_showOnlyFavorites) {
      return List<Product>.unmodifiable(_products);
    }
    return List<Product>.unmodifiable(_products.where((p) => p.favorite));
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final previousFavorites = <int>{
        for (final product in _products)
          if (product.favorite && product.id != null) product.id!,
      };

      final fetched = await _service.fetchProducts();
      _products
        ..clear()
        ..addAll(
          fetched.map(
            (product) => product.copyWith(
              favorite:
                  product.id != null && previousFavorites.contains(product.id),
            ),
          ),
        );
    } catch (_) {
      _error = 'Erro ao carregar produtos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(Product target) {
    final index = _products.indexWhere((product) {
      if (product.id != null && target.id != null) {
        return product.id == target.id;
      }
      return product.title == target.title && product.price == target.price;
    });

    if (index == -1) return;

    final product = _products[index];
    _products[index] = product.copyWith(favorite: !product.favorite);
    notifyListeners();
  }

  void toggleFavoritesFilter() {
    _showOnlyFavorites = !_showOnlyFavorites;
    notifyListeners();
  }
}
