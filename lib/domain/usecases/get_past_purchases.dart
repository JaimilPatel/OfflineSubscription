import 'package:dartz/dartz.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/core/usecase/usecase.dart';
import 'package:offline_subscription/data/repositories/subscription_repository.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class GetPastPurchases extends UseCase<List<PurchasedItem>?, NoParam> {
  final SubscriptionRepository repository;
  GetPastPurchases(this.repository);
  @override
  Future<Either<Failure, List<PurchasedItem>?>> call(NoParam params) async {
    return await repository.getPastPurchases();
  }
}
