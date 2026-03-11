import 'package:publicapi/core/errors/failure.dart';
import 'package:publicapi/data/datasources/product_cache_datasource.dart';
import 'package:publicapi/data/datasources/product_remote_datasource.dart';
import 'package:publicapi/data/models/product_model.dart';
import 'package:publicapi/domain/entities/product.dart';
import 'package:publicapi/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return _toDomain(models);
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return _toDomain(cached);
      }
      throw Failure('Não foi possível carregar os produtos');
    }
  }

  List<Product> _toDomain(List<ProductModel> models) {
    return models
        .map(
          (model) => Product(
            id: model.id,
            title: model.title,
            price: model.price,
            image: model.image,
          ),
        )
        .toList();
  }
}