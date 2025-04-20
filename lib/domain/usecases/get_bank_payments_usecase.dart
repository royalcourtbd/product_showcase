import 'package:fpdart/fpdart.dart';
import 'package:initial_project/core/base/base_use_case.dart';
import 'package:initial_project/domain/entities/payment_entity.dart';
import 'package:initial_project/domain/repositories/payment_repository.dart';
import 'package:initial_project/domain/service/error_message_handler.dart';

class GetBankPaymentsUseCase extends BaseUseCase<List<BankPaymentEntity>> {
  final PaymentRepository _paymentRepository;

  GetBankPaymentsUseCase(
    this._paymentRepository,
    ErrorMessageHandler errorMessageHandler,
  ) : super(errorMessageHandler);

  Stream<Either<String, List<BankPaymentEntity>>> execute() {
    return _paymentRepository.getBankPaymentsStream();
  }
}
