import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/base/base_use_case.dart';
import 'package:initial_project/domain/entities/payment_entity.dart';
import 'package:initial_project/domain/repositories/payment_repository.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class GetMobilePaymentsUseCase extends BaseUseCase<List<MobilePaymentEntity>> {
  final PaymentRepository _paymentRepository;

  GetMobilePaymentsUseCase(
    this._paymentRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Stream<Either<String, List<MobilePaymentEntity>>> execute() {
    return _paymentRepository.getMobilePaymentsStream();
  }
}
