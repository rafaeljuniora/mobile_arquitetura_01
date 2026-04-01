import 'package:dio/dio.dart';
import 'package:publicapi/models/product.dart';

class ProductService {
  final Dio _dio;

  ProductService([Dio? dio])
    : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com'));

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get<List<dynamic>>('/products');
    final data = response.data ?? <dynamic>[];
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> addProduct(Product product) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/products',
      data: product.toJson(),
    );
    return Product.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<Product> updateProduct(Product product) async {
    if (product.id == null) {
      throw Exception('Produto sem id para atualizar');
    }

    final response = await _dio.put<Map<String, dynamic>>(
      '/products/${product.id}',
      data: product.toJson(),
    );
    return Product.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<void> deleteProduct(String id) async {
    await _dio.delete<dynamic>('/products/$id');
  }
}
