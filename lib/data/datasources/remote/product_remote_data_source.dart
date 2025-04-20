import 'package:initial_project/core/utility/trial_utility.dart';
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
    final ProductListModel? result =
        await catchAndReturnFuture<ProductListModel>(() async {
          final Map<String, dynamic> response = await _httpClient.get(
            'https://dummyjson.com/products',
            queryParameters: {'limit': limit.toString()},
          );
          return ProductListModel.fromJson(response);
        });

    if (result == null) {
      throw Exception('Failed to fetch products');
    }

    return result;
  }

  @override
  Future<ProductListModel> searchProducts(String query) async {
    final ProductListModel? result =
        await catchAndReturnFuture<ProductListModel>(() async {
          final Map<String, dynamic> response = await _httpClient.get(
            'https://dummyjson.com/products/search',
            queryParameters: {'q': query},
          );
          return ProductListModel.fromJson(response);
        });

    if (result == null) {
      throw Exception('Failed to search products');
    }

    return result;
  }

  @override
  Future<List<String>> getCategories() async {
    final result = await catchAndReturnFuture<List<String>>(() async {
      final response = await _httpClient.get(
        'https://dummyjson.com/products/categories',
      );
      if (response.containsKey('data') && response['data'] is List<dynamic>) {
        final List<dynamic> categoriesList = response['data'] as List<dynamic>;
        return categoriesList
            .map((e) => (e as Map)['slug'].toString())
            .toList();
      } else {
        throw Exception('Invalid categories response format');
      }
    });

    if (result == null) {
      throw Exception('Failed to fetch categories');
    }

    return result;
  }

  @override
  Future<ProductListModel> getProductsByCategory(String categoryName) async {
    final ProductListModel? result =
        await catchAndReturnFuture<ProductListModel>(() async {
          final String encodedCategoryName = Uri.encodeComponent(categoryName);

          final Map<String, dynamic> response = await _httpClient.get(
            'https://dummyjson.com/products/category/$encodedCategoryName',
          );

          if (!response.containsKey('products')) {
            throw Exception('Invalid response format: products key missing');
          }

          return ProductListModel.fromJson(response);
        });

    if (result == null) {
      throw Exception('Failed to fetch products by category');
    }

    return result;
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final ProductModel? result = await catchAndReturnFuture<ProductModel>(
      () async {
        final Map<String, dynamic> response = await _httpClient.get(
          'https://dummyjson.com/products/$id',
        );
        return ProductModel.fromJson(response);
      },
    );

    if (result == null) {
      throw Exception('Failed to fetch product details');
    }

    return result;
  }
}
