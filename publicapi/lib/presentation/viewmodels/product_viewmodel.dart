import 'package:flutter/foundation.dart';
import 'package:publicapi/domain/repositories/product_repository.dart';
import 'package:publicapi/presentation/viewmodels/product_state.dart';

class ProductViewModel {
  final ProductRepository repository;
  final ValueNotifier<ProductState> state = ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true, error: null);

    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (error) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }
}