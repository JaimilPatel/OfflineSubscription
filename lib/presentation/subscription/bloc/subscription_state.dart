import 'package:equatable/equatable.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:offline_subscription/presentation/subscription/model/subscription_state_res.dart';
import 'package:offline_subscription/presentation/subscription/model/verify_receipt_android_res.dart';
import 'package:offline_subscription/presentation/subscription/model/verify_receipt_ios_res.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

//Initialize Subscription

class InitializeSubscriptionFailure extends SubscriptionState {
  final String errorMessage;
  const InitializeSubscriptionFailure({required this.errorMessage});
  @override
  String toString() => 'InitializeSubscriptionFailure';
}

class InitializeSubscriptionSuccess extends SubscriptionState {
  final String response;
  const InitializeSubscriptionSuccess({required this.response});
  @override
  String toString() => 'InitializeSubscriptionSuccess';
}

// Get Subscription Products
class GetSubscriptionProductsUninitialized extends SubscriptionState {}

class GetSubscriptionProductsFailure extends SubscriptionState {
  final String errorMessage;
  const GetSubscriptionProductsFailure({required this.errorMessage});
  @override
  String toString() => 'GetSubscriptionProductsFailure';
}

class GetSubscriptionProductsNoData extends SubscriptionState {}

class GetSubscriptionProductsSuccess extends SubscriptionState {
  final List<IAPItem> iapItems;
  const GetSubscriptionProductsSuccess({required this.iapItems});
  @override
  String toString() => 'GetSubscriptionProductsSuccess';
}

// Get Past Purchases
class GetPastPurchasesUninitialized extends SubscriptionState {}

class GetPastPurchasesFailure extends SubscriptionState {
  final String errorMessage;
  const GetPastPurchasesFailure({required this.errorMessage});
  @override
  String toString() => 'GetPastPurchasesFailure';
}

class GetPastPurchasesSuccess extends SubscriptionState {
  final List<PurchasedItem> purchasedItems;
  const GetPastPurchasesSuccess({required this.purchasedItems});
  @override
  String toString() => 'GetPastPurchasesSuccess';
}

// Purchase Subscription Product
class PurchaseSubscriptionProductLoading extends SubscriptionState {}

class PurchaseSubscriptionProductStopLoading extends SubscriptionState {}

class PurchaseSubscriptionProductFailure extends SubscriptionState {
  final String errorMessage;
  const PurchaseSubscriptionProductFailure({required this.errorMessage});
  @override
  String toString() => 'PurchaseSubscriptionProductFailure';
}

class PurchaseSubscriptionProductSuccess extends SubscriptionState {
  final Map<String, String> response;
  const PurchaseSubscriptionProductSuccess({required this.response});
  @override
  String toString() => 'PurchaseSubscriptionProductSuccess';
}

//Verify Purchase Android
class VerifyPurchaseAndroidLoading extends SubscriptionState {}

class VerifyPurchaseAndroidFailure extends SubscriptionState {
  final String errorMessage;
  const VerifyPurchaseAndroidFailure({required this.errorMessage});
  @override
  String toString() => 'VerifyPurchaseAndroidFailure';
}

class VerifyPurchaseAndroidSuccess extends SubscriptionState {
  final VerifyReceiptAndroidRes verifyReceiptAndroidRes;
  const VerifyPurchaseAndroidSuccess({required this.verifyReceiptAndroidRes});
  @override
  String toString() => 'VerifyPurchaseAndroidSuccess';
}

//Verify Purchase iOS
class VerifyPurchaseIOSLoading extends SubscriptionState {}

class VerifyPurchaseIOSFailure extends SubscriptionState {
  final String errorMessage;
  const VerifyPurchaseIOSFailure({required this.errorMessage});
  @override
  String toString() => 'VerifyPurchaseIOSFailure';
}

class VerifyPurchaseIOSSuccess extends SubscriptionState {
  final VerifyReceiptIOSRes verifyReceiptIOSRes;
  const VerifyPurchaseIOSSuccess({required this.verifyReceiptIOSRes});
  @override
  String toString() => 'VerifyPurchaseIOSSuccess';
}

//Complete Transaction

class CompleteTransactionLoading extends SubscriptionState {}

class CompleteTransactionFailure extends SubscriptionState {
  final String errorMessage;
  const CompleteTransactionFailure({required this.errorMessage});
  @override
  String toString() => 'CompleteTransactionFailure';
}

class CompleteTransactionSuccess extends SubscriptionState {
  final String finishMessage;
  const CompleteTransactionSuccess({required this.finishMessage});
  @override
  String toString() => 'CompleteTransactionSuccess';
}

//Finalize Subscription

class FinalizeSubscriptionFailure extends SubscriptionState {
  final String errorMessage;
  const FinalizeSubscriptionFailure({required this.errorMessage});
  @override
  String toString() => 'FinalizeSubscriptionFailure';
}

class FinalizeSubscriptionSuccess extends SubscriptionState {
  final String response;
  const FinalizeSubscriptionSuccess({required this.response});
  @override
  String toString() => 'FinalizeSubscriptionSuccess';
}

//Get Subscription Status

class GetSubscriptionStatusFailure extends SubscriptionState {
  final String errorMessage;
  const GetSubscriptionStatusFailure({required this.errorMessage});
  @override
  String toString() => 'GetSubscriptionStatusFailure';
}

class GetMonthlySubscriptionStatusSuccess extends SubscriptionState {
  final SubscriptionStateResponse subscriptionStateResponse;
  const GetMonthlySubscriptionStatusSuccess(
      {required this.subscriptionStateResponse});
  @override
  String toString() => 'GetMonthlySubscriptionStatusSuccess';
}

class GetYearlySubscriptionStatusSuccess extends SubscriptionState {
  final SubscriptionStateResponse subscriptionStateResponse;
  const GetYearlySubscriptionStatusSuccess(
      {required this.subscriptionStateResponse});
  @override
  String toString() => 'GetYearlySubscriptionStatusSuccess';
}

class CheckSubscriptionReadyStatusFailure extends SubscriptionState {
  final String errorMessage;
  const CheckSubscriptionReadyStatusFailure({required this.errorMessage});
  @override
  String toString() => 'CheckSubscriptionReadyStatusFailure';
}

class CheckSubscriptionReadyStatusSuccess extends SubscriptionState {
  @override
  String toString() => 'CheckSubscriptionReadyStatusSuccess';
}
