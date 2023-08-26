import 'package:equatable/equatable.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_android.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_ios.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class GetSubscriptionProductsEvent extends SubscriptionEvent {
  final List<String> productIds;

  const GetSubscriptionProductsEvent({
    required this.productIds,
  });

  @override
  List<Object> get props => [productIds];

  @override
  String toString() => 'GetSubscriptionProductsEvent Event';
}

class GetPastPurchasesEvent extends SubscriptionEvent {
  @override
  String toString() => 'GetPastPurchasesEvent Event';
}

class PurchaseSubscriptionProductLoadingEvent extends SubscriptionEvent {
  final bool isLoading;
  const PurchaseSubscriptionProductLoadingEvent({required this.isLoading});
  @override
  String toString() => 'PurchaseSubscriptionProductLoadingEvent Event';
}

class PurchaseSubscriptionProductEvent extends SubscriptionEvent {
  final String productId;
  final bool isUpgrade;
  const PurchaseSubscriptionProductEvent(
      {required this.productId, required this.isUpgrade});

  @override
  List<Object> get props => [productId];

  @override
  String toString() => 'PurchaseSubscriptionProduct Event';
}

class VerifyReceiptAndroidEvent extends SubscriptionEvent {
  final PurchaseReceiptAndroid purchaseReceiptAndroid;
  final PurchasedItem purchasedItem;

  const VerifyReceiptAndroidEvent({
    required this.purchaseReceiptAndroid,
    required this.purchasedItem,
  });

  @override
  List<Object> get props => [purchaseReceiptAndroid, purchasedItem];

  @override
  String toString() => 'VerifyReceiptAndroid Event';
}

class VerifyReceiptIOSEvent extends SubscriptionEvent {
  final PurchaseReceiptIOS purchaseReceiptIOS;

  const VerifyReceiptIOSEvent({
    required this.purchaseReceiptIOS,
  });

  @override
  List<Object> get props => [purchaseReceiptIOS];

  @override
  String toString() => 'VerifyReceiptIOS Event';
}

class CompleteTransactionEvent extends SubscriptionEvent {
  final PurchasedItem? purchasedItem;
  final String? transactionId;
  final bool? isConsumable;

  const CompleteTransactionEvent(
      {this.purchasedItem, this.transactionId, this.isConsumable});

  @override
  String toString() => 'CompleteTransactionEvent Event';
}

class InitializeSubscriptionEvent extends SubscriptionEvent {
  @override
  String toString() => 'InitializeSubscriptionEvent Event';
}

class FinalizeSubscriptionEvent extends SubscriptionEvent {
  @override
  String toString() => 'FinalizeSubscriptionEvent Event';
}

class GetSubscriptionStatusEvent extends SubscriptionEvent {
  final String productId;

  const GetSubscriptionStatusEvent({
    required this.productId,
  });

  @override
  List<Object> get props => [productId];

  @override
  String toString() => 'GetSubscriptionStatusEvent Event';
}

class CheckSubscriptionReadyStatusEvent extends SubscriptionEvent {
  @override
  String toString() => 'CheckSubscriptionReadyStatusEvent Event';
}
