import 'package:flutter/foundation.dart';
import 'package:publicapi/models/product.dart';
import 'package:publicapi/services/product_service.dart';
import 'package:publicapi/services/session_manager.dart';

class ProductFavoritesProvider extends ChangeNotifier {
  final ProductService _service;
  final SessionManager _session = SessionManager();

  ProductFavoritesProvider(this._service) {
    _loadFavoriteIds();
  }

  final List<Product> _products = <Product>[];
  final Set<int> _favoriteIds = <int>{};
  bool _isLoading = false;
  bool _showOnlyFavorites = false;
  String? _error;

  bool get isLoading => _isLoading;
  bool get showOnlyFavorites => _showOnlyFavorites;
  String? get error => _error;

  int get favoriteCount => _favoriteIds.length;

  bool isFavorite(int? id) => id != null && _favoriteIds.contains(id);

  List<Product> get products {
    if (!_showOnlyFavorites) {
      return List<Product>.unmodifiable(_products);
    }
    return List<Product>.unmodifiable(
      _products.where((p) => isFavorite(p.id)),
    );
  }

  Future<void> _loadFavoriteIds() async {
    final ids = await _session.getFavoriteProductIds();
    _favoriteIds
      ..clear()
      ..addAll(ids);
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _service.fetchProducts();
      _products
        ..clear()
        ..addAll(fetched);
    } catch (_) {
      _error = 'Erro ao carregar produtos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Product target) async {
    final id = target.id;
    if (id == null) return;

    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();

    await _session.saveFavoriteProductIds(_favoriteIds);
  }

  void toggleFavoritesFilter() {
    _showOnlyFavorites = !_showOnlyFavorites;
    notifyListeners();
  }
}
