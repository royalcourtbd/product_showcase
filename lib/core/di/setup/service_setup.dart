import 'package:get_it/get_it.dart';
import 'package:initial_project/core/di/setup/setup_module.dart';
import 'package:initial_project/data/services/backend_as_a_service.dart';
import 'package:initial_project/data/services/error_message_handler_impl.dart';
import 'package:initial_project/data/services/local_cache_service.dart';
import 'package:initial_project/data/services/notification/notification_service_impl.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';
import 'package:initial_project/domain/service/notification_service.dart';
import 'package:initial_project/domain/service/time_service.dart';

class ServiceSetup implements SetupModule {
  final GetIt _serviceLocator;
  ServiceSetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton<ErrorMessageHandler>(ErrorMessageHandlerImpl.new)
      ..registerLazySingleton<NotificationService>(NotificationServiceImpl.new)
      ..registerLazySingleton<BackendAsAService>(BackendAsAService.new)
      ..registerLazySingleton<TimeService>(TimeService.new)
      ..registerLazySingleton<LocalCacheService>(LocalCacheService.new);

    await LocalCacheService.setUp();
  }
}
