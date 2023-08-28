import 'dart:io';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:offline_subscription/core/error/exception.dart';
import 'package:offline_subscription/core/sharepref_helper.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_android.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_ios.dart';
import 'package:offline_subscription/presentation/subscription/model/subscription_state_res.dart';
import 'package:offline_subscription/presentation/subscription/model/verify_receipt_android_res.dart';
import 'package:offline_subscription/presentation/subscription/model/verify_receipt_ios_res.dart';
import 'package:http/http.dart' as http;

abstract class SubscriptionDataSource {
  Future<String?> initializeSubscription();
  Future<int> checkSubscriptionReadyStatus();
  Future<List<IAPItem>> getSubscriptionProducts(List<String> products);
  Future<List<PurchasedItem>?> getPastPurchases();
  Future<Map<String, String>> purchaseSubscriptionProduct(String productId,
      {bool isUpgrade = false});
  Future<VerifyReceiptAndroidRes> verifyReceiptForAndroid(
      PurchaseReceiptAndroid purchaseReceiptAndroid,
      PurchasedItem purchasedItem);
  Future<VerifyReceiptIOSRes> verifyReceiptForIOS(
      PurchaseReceiptIOS purchaseReceiptIOS);
  Future<String> completeTransaction(
      {PurchasedItem? item, String? transactionId, bool? isConsumable});
  Future<String?> finalizeSubscription();
  Future<SubscriptionStateResponse> getSubscriptionStatus(String productId);
}

class SubscriptionDataSourceImpl extends SubscriptionDataSource {
  @override
  Future<List<IAPItem>> getSubscriptionProducts(List<String> products) async {
    try {
      await _initializeSubscriptionIfNot();
      List<IAPItem> inAppPurchaseItems =
          await FlutterInappPurchase.instance.getSubscriptions(products);
      return inAppPurchaseItems;
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<Map<String, String>> purchaseSubscriptionProduct(String productId,
      {bool isUpgrade = false}) async {
    try {
      Map<String, String> data;
      await _initializeSubscriptionIfNot();
      if (isUpgrade) {
        if (Platform.isAndroid) {
          data = await FlutterInappPurchase.instance.requestSubscription(
              productId,
              prorationModeAndroid:
                  AndroidProrationMode.IMMEDIATE_AND_CHARGE_FULL_PRICE,
              purchaseTokenAndroid:
                  SharedPreferenceHelper.getLastPurchaseToken() ?? "");
        } else {
          data = await FlutterInappPurchase.instance
              .requestSubscription(productId);
        }
      } else {
        data =
            await FlutterInappPurchase.instance.requestSubscription(productId);
      }
      return data;
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<VerifyReceiptAndroidRes> verifyReceiptForAndroid(
      PurchaseReceiptAndroid purchaseReceiptAndroid,
      PurchasedItem purchasedItem) async {
    try {
      await _initializeSubscriptionIfNot();
      http.Response isValid = await FlutterInappPurchase.instance
          .validateReceiptAndroid(
              packageName: purchaseReceiptAndroid.packageName,
              productId: purchaseReceiptAndroid.productId,
              productToken: purchaseReceiptAndroid.productToken,
              accessToken: purchaseReceiptAndroid.accessToken,
              isSubscription: true);
      VerifyReceiptAndroidRes model = VerifyReceiptAndroidRes(
          purchaseReceiptAndroid: purchaseReceiptAndroid,
          response: isValid,
          purchasedItem: purchasedItem);
      return model;
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<VerifyReceiptIOSRes> verifyReceiptForIOS(
      PurchaseReceiptIOS purchaseReceiptIOS) async {
    try {
      await _initializeSubscriptionIfNot();
      http.Response isValid = await FlutterInappPurchase.instance
          .validateReceiptIos(
              receiptBody: purchaseReceiptIOS.receiptBody, isTest: true);
      VerifyReceiptIOSRes model = VerifyReceiptIOSRes(
          purchaseReceiptIOS: purchaseReceiptIOS, response: isValid);
      return model;
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<String> completeTransaction(
      {PurchasedItem? item, String? transactionId, bool? isConsumable}) async {
    try {
      String finishMessage;
      await _initializeSubscriptionIfNot();
      if (Platform.isIOS) {
        finishMessage = await FlutterInappPurchase.instance
                .finishTransactionIOS(transactionId ?? "") ??
            "";
      } else {
        if (item != null) {
          finishMessage =
              await FlutterInappPurchase.instance.finishTransaction(item) ?? "";
        } else {
          finishMessage = "";
        }
      }
      return Future.value(finishMessage);
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<String?> initializeSubscription() async {
    try {
      String? result = await FlutterInappPurchase.instance.initialize();
      return Future.value(result);
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<int> checkSubscriptionReadyStatus() async {
    try {
      if (await FlutterInappPurchase.instance.isReady()) {
        return Future.value(1);
      } else {
        return Future.value(0);
      }
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<String?> finalizeSubscription() async {
    try {
      String? result = await FlutterInappPurchase.instance.finalize();
      return Future.value(result);
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<List<PurchasedItem>?> getPastPurchases() async {
    List<PurchasedItem>? purchasedItems;
    try {
      await _initializeSubscriptionIfNot();
      purchasedItems = await FlutterInappPurchase.instance.getPurchaseHistory();
      return Future.value(purchasedItems);
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  @override
  Future<SubscriptionStateResponse> getSubscriptionStatus(
      String productId) async {
    try {
      await _initializeSubscriptionIfNot();
      bool result =
          await FlutterInappPurchase.instance.checkSubscribed(sku: productId);
      return Future.value(
          SubscriptionStateResponse(productId: productId, isActive: result));
    } on Failure catch (_) {
      rethrow;
    } catch (error) {
      throw UnknownException(error.toString());
    }
  }

  Future _initializeSubscriptionIfNot() async {
    if (await FlutterInappPurchase.instance.isReady() == false) {
      await FlutterInappPurchase.instance.initialize();
    }
  }
}
