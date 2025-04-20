import 'package:initial_project/data/models/product_model.dart';
import 'package:initial_project/data/services/http_client_impl.dart';

abstract class ProductRemoteDataSource {
  Future<ProductListModel> getProducts({int limit = 100});
  Future<ProductListModel> searchProducts(String query);
  Future<List<String>> getCategories();
  Future<ProductListModel> getProductsByCategory(String categoryName);
  Future<ProductModel> getProductDetails(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final HttpClient _httpClient;

  ProductRemoteDataSourceImpl(this._httpClient);

  @override
  Future<ProductListModel> getProducts({int limit = 100}) async {
    try {
      final response = await _httpClient.get(
        'https://dummyjson.com/products',
        queryParameters: {'limit': limit.toString()},
      );
      return ProductListModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to fetch products: $error');
    }
  }

  @override
  Future<ProductListModel> searchProducts(String query) async {
    try {
      final response = await _httpClient.get(
        'https://dummyjson.com/products/search',
        queryParameters: {'q': query},
      );
      return ProductListModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to search products: $error');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _httpClient.get(
        'https://dummyjson.com/products/categories',
      );
      if (response.containsKey('data') && response['data'] is List<dynamic>) {
        final List<dynamic> categoriesList = response['data'] as List<dynamic>;
        return categoriesList.map((e) => e.toString()).toList();
      } else {
        throw Exception('Invalid categories response format');
      }
    } catch (error) {
      throw Exception('Failed to fetch categories: $error');
    }
  }

  @override
  Future<ProductListModel> getProductsByCategory(String categoryName) async {
    try {
      final String encodedCategoryName = Uri.encodeComponent(categoryName);

      final response = await _httpClient.get(
        'https://dummyjson.com/products/category/$encodedCategoryName',
      );

      if (!response.containsKey('products')) {
        throw Exception('Invalid response format: products key missing');
      }

      return ProductListModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to fetch products by category: $error');
    }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    try {
      final response = await _httpClient.get(
        'https://dummyjson.com/products/$id',
      );
      return ProductModel.fromJson(response);
    } catch (error) {
      throw Exception('Failed to fetch product details: $error');
    }
  }
}
