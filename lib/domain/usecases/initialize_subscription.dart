import 'package:dartz/dartz.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/core/usecase/usecase.dart';
import 'package:offline_subscription/data/repositories/subscription_repository.dart';

class InitializeSubscription extends UseCase<dynamic, NoParam> {
  final SubscriptionRepository repository;
  InitializeSubscription(this.repository);
  @override
  Future<Either<Failure, dynamic>> call(NoParam params) {
    return repository.initializeSubscription();
  }
}
