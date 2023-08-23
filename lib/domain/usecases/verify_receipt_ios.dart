import 'package:dartz/dartz.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/core/usecase/usecase.dart';
import 'package:offline_subscription/data/repositories/subscription_repository.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_ios.dart';
import 'package:offline_subscription/presentation/subscription/model/verify_receipt_ios_res.dart';

class VerifyReceiptIOS
    extends UseCase<VerifyReceiptIOSRes, VerifyReceiptIOSParam> {
  final SubscriptionRepository repository;
  VerifyReceiptIOS(this.repository);
  @override
  Future<Either<Failure, VerifyReceiptIOSRes>> call(
      VerifyReceiptIOSParam params) {
    return repository.verifyReceiptForIOS(params.purchaseReceiptIOS);
  }
}

class VerifyReceiptIOSParam implements NoParam {
  final PurchaseReceiptIOS purchaseReceiptIOS;

  VerifyReceiptIOSParam(this.purchaseReceiptIOS);

  @override
  List<Object?> get props => [purchaseReceiptIOS];

  @override
  bool? get stringify => true;
}
