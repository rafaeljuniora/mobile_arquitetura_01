import 'package:flutter/material.dart';
import 'package:publicapi/core/network/http_client.dart';
import 'package:publicapi/data/datasources/product_cache_datasource.dart';
import 'package:publicapi/data/datasources/product_remote_datasource.dart';
import 'package:publicapi/data/repositories/product_repository_impl.dart';
import 'package:publicapi/presentation/pages/home_page.dart';
import 'package:publicapi/presentation/viewmodels/product_viewmodel.dart';

void main() {
  final client = HttpClient();
  final remoteDatasource = ProductRemoteDatasource(client);
  final cacheDatasource = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(remoteDatasource, cacheDatasource);
  final viewModel = ProductViewModel(repository);

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Public API Products',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: HomePage(viewModel: viewModel),
    );
  }
}
