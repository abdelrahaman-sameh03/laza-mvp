import 'package:flutter/foundation.dart';
import '../data/product_model.dart';
import '../data/products_api.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductsApi _api = ProductsApi();

  bool loading = false;
  String? error;
  List<Product> _all = [];
  String _query = '';

  List<Product> get products {
    if (_query.trim().isEmpty) return _all;
    final q = _query.toLowerCase();
    return _all.where((p) => p.title.toLowerCase().contains(q)).toList();
  }

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      _all = await _api.fetchProducts();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void setQuery(String v) {
    _query = v;
    notifyListeners();
  }

  Future<Product> getById(int id) => _api.fetchProduct(id);
}
