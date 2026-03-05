import 'package:publicapi/data/datasources/product_remote_datasource.dart';
import 'package:publicapi/domain/entities/product.dart';
import 'package:publicapi/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts() async {
    final models = await datasource.getProducts();
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