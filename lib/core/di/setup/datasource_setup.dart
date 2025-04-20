import 'package:get_it/get_it.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/di/setup/setup_module.dart';
import 'package:initial_project/data/datasources/local/user_data_local_data_source.dart';
import 'package:initial_project/data/datasources/remote/product_remote_data_source.dart';

class DatasourceSetup implements SetupModule {
  final GetIt _serviceLocator;
  DatasourceSetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton(() => UserDataLocalDataSource(locate()))
      ..registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(locate()),
      );
  }
}
