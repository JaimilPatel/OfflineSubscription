import 'package:dartz/dartz.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/core/usecase/usecase.dart';
import 'package:offline_subscription/data/repositories/subscription_repository.dart';
import 'package:offline_subscription/presentation/subscription/model/subscription_state_res.dart';

class GetSubscriptionStatus
    extends UseCase<SubscriptionStateResponse, GetSubscriptionStatusParam> {
  SubscriptionRepository repository;
  GetSubscriptionStatus(this.repository);
  @override
  Future<Either<Failure, SubscriptionStateResponse>> call(
      GetSubscriptionStatusParam params) {
    return repository.getSubscriptionStatus(params.productId);
  }
}

class GetSubscriptionStatusParam extends NoParam {
  final String productId;
  GetSubscriptionStatusParam(this.productId);

  @override
  List<Object?> get props => [productId];

  @override
  bool? get stringify => true;
}
