import 'package:dartz/dartz.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/core/usecase/usecase.dart';
import 'package:offline_subscription/data/repositories/subscription_repository.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_android.dart';
import 'package:offline_subscription/presentation/subscription/model/verify_receipt_android_res.dart';

class VerifyReceiptAndroid
    extends UseCase<VerifyReceiptAndroidRes, VerifyReceiptAndroidParam> {
  final SubscriptionRepository repository;
  VerifyReceiptAndroid(this.repository);
  @override
  Future<Either<Failure, VerifyReceiptAndroidRes>> call(
      VerifyReceiptAndroidParam params) {
    return repository.verifyReceiptForAndroid(
        params.purchaseReceiptAndroid, params.purchasedItem);
  }
}

class VerifyReceiptAndroidParam implements NoParam {
  final PurchaseReceiptAndroid purchaseReceiptAndroid;
  final PurchasedItem purchasedItem;

  VerifyReceiptAndroidParam(this.purchaseReceiptAndroid, this.purchasedItem);

  @override
  List<Object?> get props => [purchaseReceiptAndroid, purchasedItem];

  @override
  bool? get stringify => true;
}
