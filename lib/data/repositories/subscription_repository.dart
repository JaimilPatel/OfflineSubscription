import 'package:dartz/dartz.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/data/datasources/subscription_datasource.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_android.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_ios.dart';
import 'package:offline_subscription/presentation/subscription/model/subscription_state_res.dart';
import 'package:offline_subscription/presentation/subscription/model/verify_receipt_android_res.dart';
import 'package:offline_subscription/presentation/subscription/model/verify_receipt_ios_res.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, String?>> initializeSubscription();
  Future<Either<Failure, int>> checkSubscriptionReadyStatus();
  Future<Either<Failure, List<IAPItem>>> getSubscriptionProducts(
      List<String> products);
  Future<Either<Failure, List<PurchasedItem>?>> getPastPurchases();
  Future<Either<Failure, Map<String, String>>> purchaseSubscriptionProduct(
      String productId,
      {bool isUpgrade = false});
  Future<Either<Failure, VerifyReceiptAndroidRes>> verifyReceiptForAndroid(
      PurchaseReceiptAndroid purchaseReceiptAndroid,
      PurchasedItem purchasedItem);
  Future<Either<Failure, VerifyReceiptIOSRes>> verifyReceiptForIOS(
      PurchaseReceiptIOS purchaseReceiptIOS);
  Future<Either<Failure, String>> completeTransaction(
      {PurchasedItem item, String transactionId, bool isConsumable});
  Future<Either<Failure, String?>> finalizeSubscription();
  Future<Either<Failure, SubscriptionStateResponse>> getSubscriptionStatus(
      String productId);
}

class SubscriptionRepositoryImpl extends SubscriptionRepository {
  final SubscriptionDataSource dataSource;
  SubscriptionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<IAPItem>>> getSubscriptionProducts(
      List<String> products) async {
    try {
      List<IAPItem> items = await dataSource.getSubscriptionProducts(products);
      return Right(items);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> purchaseSubscriptionProduct(
      String productId,
      {bool isUpgrade = false}) async {
    try {
      Map<String, String> item = await dataSource
          .purchaseSubscriptionProduct(productId, isUpgrade: isUpgrade);
      return Right(item);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyReceiptAndroidRes>> verifyReceiptForAndroid(
      PurchaseReceiptAndroid purchaseReceiptAndroid,
      PurchasedItem purchasedItem) async {
    try {
      VerifyReceiptAndroidRes item = await dataSource.verifyReceiptForAndroid(
          purchaseReceiptAndroid, purchasedItem);
      return Right(item);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyReceiptIOSRes>> verifyReceiptForIOS(
      PurchaseReceiptIOS purchaseReceiptIOS) async {
    try {
      VerifyReceiptIOSRes item =
          await dataSource.verifyReceiptForIOS(purchaseReceiptIOS);
      return Right(item);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> completeTransaction(
      {PurchasedItem? item, String? transactionId, bool? isConsumable}) async {
    try {
      String completeMessage = await dataSource.completeTransaction(
          item: item, transactionId: transactionId, isConsumable: isConsumable);
      return Right(completeMessage);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> initializeSubscription() async {
    try {
      String? completeMessage = await dataSource.initializeSubscription();
      return Right(completeMessage);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> finalizeSubscription() async {
    try {
      String? completeMessage = await dataSource.finalizeSubscription();
      return Right(completeMessage);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PurchasedItem>?>> getPastPurchases() async {
    try {
      List<PurchasedItem>? items = await dataSource.getPastPurchases();
      return Right(items);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionStateResponse>> getSubscriptionStatus(
      String productId) async {
    try {
      SubscriptionStateResponse result =
          await dataSource.getSubscriptionStatus(productId);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> checkSubscriptionReadyStatus() async {
    try {
      int result = await dataSource.checkSubscriptionReadyStatus();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownException(e.toString()));
    }
  }
}
