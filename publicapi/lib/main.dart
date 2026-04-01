import 'package:flutter/material.dart';
import 'package:publicapi/screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool autoLoadProducts;

  const MyApp({super.key, this.autoLoadProducts = true});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product CRUD',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: ProductListScreen(autoLoad: autoLoadProducts),
    );
  }
}
