import 'package:dartz/dartz.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/core/usecase/usecase.dart';
import 'package:offline_subscription/data/repositories/subscription_repository.dart';

class PurchaseSubscriptionProduct
    extends UseCase<Map<String, String>, PurchaseSubscriptionProductParam> {
  SubscriptionRepository repository;
  PurchaseSubscriptionProduct(this.repository);
  @override
  Future<Either<Failure, Map<String, String>>> call(
      PurchaseSubscriptionProductParam params) {
    return repository.purchaseSubscriptionProduct(params.productId,
        isUpgrade: params.isUpgrade);
  }
}

class PurchaseSubscriptionProductParam extends NoParam {
  final String productId;
  final bool isUpgrade;
  PurchaseSubscriptionProductParam(this.productId, this.isUpgrade);

  @override
  List<Object?> get props => [productId, isUpgrade];

  @override
  bool? get stringify => true;
}
