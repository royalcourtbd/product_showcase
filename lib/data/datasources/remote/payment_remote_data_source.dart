import 'package:initial_project/core/utility/logger_utility.dart';
import 'package:initial_project/data/models/payment_model.dart';
import 'package:initial_project/data/services/backend_as_a_service.dart';

abstract class PaymentRemoteDataSource {
  Stream<List<BankPaymentModel>> getBankPaymentsStream();
  Stream<List<MobilePaymentModel>> getMobilePaymentsStream();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final BackendAsAService _backendAsAService;

  PaymentRemoteDataSourceImpl(this._backendAsAService);

  @override
  Stream<List<BankPaymentModel>> getBankPaymentsStream() {
    return _backendAsAService.getBankPaymentsStream().handleError((error) {
      logError('Error in bank payments stream: $error');
      return <BankPaymentModel>[];
    });
  }

  @override
  Stream<List<MobilePaymentModel>> getMobilePaymentsStream() {
    return _backendAsAService.getMobilePaymentsStream().handleError((error) {
      logError('Error in mobile payments stream: $error');
      return <MobilePaymentModel>[];
    });
  }
}
