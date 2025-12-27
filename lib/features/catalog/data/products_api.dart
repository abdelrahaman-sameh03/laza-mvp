import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import 'product_model.dart';

class ProductsApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
    ),
  );

  Future<List<Product>> fetchProducts() async {
    final res = await _dio.get('/products');
    return (res.data as List)
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Product> fetchProduct(int id) async {
    final res = await _dio.get('/products/$id');
    return Product.fromJson(Map<String, dynamic>.from(res.data));
  }
}
