// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:publicapi/core/network/http_client.dart';
import 'package:publicapi/data/datasources/product_remote_datasource.dart';
import 'package:publicapi/data/repositories/product_repository_impl.dart';
import 'package:publicapi/main.dart';
import 'package:publicapi/presentation/viewmodels/product_viewmodel.dart';

void main() {
  testWidgets('Carrega tela de produtos', (WidgetTester tester) async {
    final client = HttpClient();
    final datasource = ProductRemoteDatasource(client);
    final repository = ProductRepositoryImpl(datasource);
    final viewModel = ProductViewModel(repository);

    await tester.pumpWidget(MyApp(viewModel: viewModel));

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.text('Carregar Produtos'), findsOneWidget);
  });
}
