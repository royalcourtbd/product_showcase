import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/di/setup/setup_module.dart';
import 'package:initial_project/domain/usecases/determine_first_run_use_case.dart';
import 'package:initial_project/domain/usecases/get_categories_usecase.dart';
import 'package:initial_project/domain/usecases/get_product_details_usecase.dart';
import 'package:initial_project/domain/usecases/get_product_usecase.dart';
import 'package:initial_project/domain/usecases/get_products_by_category_usecase.dart';

import 'package:initial_project/domain/usecases/save_first_time_use_case.dart';
import 'package:initial_project/domain/usecases/search_product_usecase.dart';

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
      ..registerLazySingleton(() => GetProductsUseCase(locate(), locate()))
      ..registerLazySingleton(
        () => GetProductsByCategoryUseCase(locate(), locate()),
      )
      ..registerLazySingleton(() => GetCategoriesUseCase(locate(), locate()))
      ..registerLazySingleton(
        () => GetProductDetailsUseCase(locate(), locate()),
      )
      ..registerLazySingleton(() => SearchProductsUseCase(locate(), locate()));
  }
}
