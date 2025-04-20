import 'package:fpdart/fpdart.dart';
import 'package:initial_project/domain/entities/device_info_entity.dart';

abstract class DeviceInfoRepository {
  /// Register a device
  Future<void> registerDevice();

  /// Get all registered devices
  Stream<Either<String, List<DeviceInfoEntity>>> getAllRegisteredDevices();
}
