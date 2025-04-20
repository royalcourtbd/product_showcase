import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/di/setup/setup_module.dart';
import 'package:initial_project/domain/usecases/check_notification_permission_usecase.dart';
import 'package:initial_project/domain/usecases/determine_first_run_use_case.dart';
import 'package:initial_project/domain/usecases/get_bank_payments_usecase.dart';
import 'package:initial_project/domain/usecases/get_device_info_usecase.dart';
import 'package:initial_project/domain/usecases/get_mobile_payments_usecase.dart';
import 'package:initial_project/domain/usecases/register_device_usecase.dart';
import 'package:initial_project/domain/usecases/request_notification_permission_usecase.dart';
import 'package:initial_project/domain/usecases/save_first_time_use_case.dart';

class UsecaseSetup implements SetupModule {
  final GetIt _serviceLocator;
  UsecaseSetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    log('init usecase setup');
    _serviceLocator
      ..registerLazySingleton(
        () => DetermineFirstRunUseCase(locate(), locate()),
      )
      ..registerLazySingleton(() => SaveFirstTimeUseCase(locate(), locate()))
      ..registerLazySingleton(() => GetDeviceInfoUsecase(locate(), locate()))
      ..registerLazySingleton(() => RegisterDeviceUsecase(locate(), locate()))
      ..registerLazySingleton(() => GetBankPaymentsUseCase(locate(), locate()))
      ..registerLazySingleton(
        () => GetMobilePaymentsUseCase(locate(), locate()),
      )
      ..registerLazySingleton(
        () => CheckNotificationPermissionUsecase(locate(), locate()),
      )
      ..registerLazySingleton(
        () => RequestNotificationPermissionUsecase(locate(), locate()),
      );
  }
}
