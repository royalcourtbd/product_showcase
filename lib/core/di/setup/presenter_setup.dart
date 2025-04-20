import 'package:get_it/get_it.dart';
import 'package:initial_project/core/base/base_presenter.dart';
import 'package:initial_project/core/di/service_locator.dart';
import 'package:initial_project/core/di/setup/setup_module.dart';
import 'package:initial_project/presentation/home/presenter/home_presenter.dart';

import 'package:initial_project/presentation/product/presenter/product_details_presenter.dart';
import 'package:initial_project/presentation/product/presenter/product_list_presenter.dart';

class PresenterSetup implements SetupModule {
  final GetIt _serviceLocator;
  PresenterSetup(this._serviceLocator);

  @override
  Future<void> setup() async {
    _serviceLocator
      ..registerLazySingleton(() => loadPresenter(HomePresenter()))
      ..registerLazySingleton(
        () => loadPresenter(
          ProductListPresenter(locate(), locate(), locate(), locate()),
        ),
      )
      ..registerLazySingleton(
        () => loadPresenter(ProductDetailPresenter(locate())),
      );
  }
}
