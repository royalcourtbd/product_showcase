import 'package:get_it/get_it.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/di/setup/setup_module.dart';

import 'package:initial_project/data/repositories/product_repository_impl.dart';
import 'package:initial_project/data/repositories/user_data_repository_impl.dart';

import 'package:initial_project/domain/repositories/product_repository.dart';
import 'package:initial_project/domain/repositories/user_data_repository.dart';

class RepositorySetup implements SetupModule {
  final GetIt _serviceLocator;
  RepositorySetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton<UserDataRepository>(
        () => UserDataRepositoryImpl(locate()),
      )
      ..registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(locate(), locate()),
      );
  }
}
