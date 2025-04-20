import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/base/base_use_case.dart';
import 'package:initial_project/domain/service/notification_service.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class CheckNotificationPermissionUsecase extends BaseUseCase<bool> {
  final NotificationService _notificationService;

  CheckNotificationPermissionUsecase(
    this._notificationService,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Future<Either<String, bool>> execute() async {
    return mapResultToEither(() async {
      return await _notificationService.isNotificationAllowed();
    });
  }
}
