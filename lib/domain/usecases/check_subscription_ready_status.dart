import 'package:dartz/dartz.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/core/usecase/usecase.dart';
import 'package:offline_subscription/data/repositories/subscription_repository.dart';

class CheckSubscriptionReadyStatus extends UseCase<int, NoParam> {
  SubscriptionRepository repository;
  CheckSubscriptionReadyStatus(this.repository);
  @override
  Future<Either<Failure, int>> call(NoParam params) {
    return repository.checkSubscriptionReadyStatus();
  }
}
