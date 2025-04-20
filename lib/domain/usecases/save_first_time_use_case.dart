import 'package:initial_project/core/base/base_use_case.dart';
import 'package:initial_project/domain/repositories/user_data_repository.dart';

class SaveFirstTimeUseCase extends BaseUseCase<void> {
  final UserDataRepository userDataRepository;

  SaveFirstTimeUseCase(super.errorMessageHandler, this.userDataRepository);

  Future<void> execute() async {
    await doVoid(() => userDataRepository.doneFirstTime());
  }
}
