import 'package:get_it/get_it.dart';
import 'package:initial_project/core/di/setup/setup_module.dart';
import 'package:initial_project/data/services/error_message_handler_impl.dart';
import 'package:initial_project/data/services/http_client_impl.dart';
import 'package:initial_project/data/services/local_cache_service.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class ServiceSetup implements SetupModule {
  final GetIt _serviceLocator;
  ServiceSetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton<ErrorMessageHandler>(ErrorMessageHandlerImpl.new)
      ..registerLazySingleton<LocalCacheService>(LocalCacheService.new)
      ..registerLazySingleton<HttpClient>(HttpClientImpl.new);

    await LocalCacheService.setUp();
  }
}
