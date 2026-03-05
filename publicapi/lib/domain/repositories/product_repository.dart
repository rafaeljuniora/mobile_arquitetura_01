import 'package:publicapi/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}