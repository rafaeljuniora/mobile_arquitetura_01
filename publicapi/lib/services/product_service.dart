import 'package:dio/dio.dart';
import 'package:publicapi/models/product.dart';
import 'package:publicapi/core/api_client.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();
  late final Dio _dio;

  ProductService() {
    _dio = _apiClient.dio;
  }

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get<Map<String, dynamic>>('/products');
    final data = response.data?['products'] as List<dynamic>? ?? <dynamic>[];
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProductById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/products/$id');
    return Product.fromJson(response.data ?? <String, dynamic>{});
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
