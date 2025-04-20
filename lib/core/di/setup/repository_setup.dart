import 'package:get_it/get_it.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/di/setup/setup_module.dart';
import 'package:initial_project/data/repositories/device_info_repository_impl.dart';
import 'package:initial_project/data/repositories/payment_repository_impl.dart';
import 'package:initial_project/data/repositories/user_data_repository_impl.dart';
import 'package:initial_project/domain/repositories/device_info_repository.dart';
import 'package:initial_project/domain/repositories/payment_repository.dart';
import 'package:initial_project/domain/repositories/user_data_repository.dart';

class RepositorySetup implements SetupModule {
  final GetIt _serviceLocator;
  RepositorySetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton<UserDataRepository>(
        () => UserDataRepositoryImpl(locate(), locate()),
      )
      ..registerLazySingleton<PaymentRepository>(
        () => PaymentRepositoryImpl(locate(), locate()),
      )
      ..registerLazySingleton<DeviceInfoRepository>(
        () => DeviceInfoRepositoryImpl(locate(), locate(), locate()),
      );
  }
}
