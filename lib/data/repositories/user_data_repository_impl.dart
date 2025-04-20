import 'package:initial_project/core/utility/trial_utility.dart';
import 'package:initial_project/data/datasources/local/user_data_local_data_source.dart';
import 'package:initial_project/domain/repositories/user_data_repository.dart';

class UserDataRepositoryImpl extends UserDataRepository {
  UserDataRepositoryImpl(this._userDataLocalDataSource);

  final UserDataLocalDataSource _userDataLocalDataSource;

  @override
  Future<void> doneFirstTime() => _userDataLocalDataSource.doneFirstTime();

  @override
  Future<bool> determineFirstRun() async {
    final bool? shouldCountAsFirstTime = await catchAndReturnFuture(() async {
      final bool isFirstTime =
          await _userDataLocalDataSource.determineFirstRun();
      if (isFirstTime) return true;
      return false;
    });

    return shouldCountAsFirstTime ?? true;
  }
}
