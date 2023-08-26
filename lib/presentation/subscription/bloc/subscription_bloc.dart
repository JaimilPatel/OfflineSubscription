import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_subscription/core/constant/app_constant.dart';
import 'package:offline_subscription/core/usecase/usecase.dart';
import 'package:offline_subscription/domain/usecases/check_subscription_ready_status.dart';
import 'package:offline_subscription/domain/usecases/complete_transaction.dart';
import 'package:offline_subscription/domain/usecases/finalize_subscription.dart';
import 'package:offline_subscription/domain/usecases/get_past_purchases.dart';
import 'package:offline_subscription/domain/usecases/get_subscription_products.dart';
import 'package:offline_subscription/domain/usecases/get_subscription_status.dart';
import 'package:offline_subscription/domain/usecases/initialize_subscription.dart';
import 'package:offline_subscription/domain/usecases/purchase_subscription_product.dart';
import 'package:offline_subscription/domain/usecases/verify_receipt_android.dart';
import 'package:offline_subscription/domain/usecases/verify_receipt_ios.dart';
import 'package:offline_subscription/presentation/subscription/bloc/subscription_event.dart';
import 'package:offline_subscription/presentation/subscription/bloc/subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final InitializeSubscription initializeSubscription;
  final GetSubscriptionProducts getSubscriptionProducts;
  final GetPastPurchases getPastPurchases;
  final PurchaseSubscriptionProduct purchaseSubscriptionProduct;
  final VerifyReceiptAndroid verifyReceiptAndroid;
  final VerifyReceiptIOS verifyReceiptIOS;
  final CompleteTransaction completeTransaction;
  final FinalizeSubscription finalizeSubscription;
  final GetSubscriptionStatus getSubscriptionStatus;
  final CheckSubscriptionReadyStatus checkSubscriptionReadyStatus;

  SubscriptionBloc(
      {required this.initializeSubscription,
      required this.getSubscriptionProducts,
      required this.getPastPurchases,
      required this.purchaseSubscriptionProduct,
      required this.verifyReceiptAndroid,
      required this.verifyReceiptIOS,
      required this.completeTransaction,
      required this.finalizeSubscription,
      required this.getSubscriptionStatus,
      required this.checkSubscriptionReadyStatus})
      : super(GetSubscriptionProductsUninitialized()) {
    on<InitializeSubscriptionEvent>(onInitializeSubscription);
    on<GetSubscriptionProductsEvent>(onGetSubscriptionProducts);
    on<GetPastPurchasesEvent>(onGetPastPurchases);
    on<PurchaseSubscriptionProductEvent>(onPurchaseProduct);
    on<PurchaseSubscriptionProductLoadingEvent>(onPurchaseProductLoading);
    on<VerifyReceiptAndroidEvent>(onVerifyReceiptAndroid);
    on<VerifyReceiptIOSEvent>(onVerifyReceiptIOS);
    on<CompleteTransactionEvent>(onCompleteTransaction);
    on<GetSubscriptionStatusEvent>(onGetSubscriptionStatus);
    on<FinalizeSubscriptionEvent>(onFinalizeSubscription);
    on<CheckSubscriptionReadyStatusEvent>(onCheckSubscriptionReadyStatus);
  }

  Future<void> onInitializeSubscription(InitializeSubscriptionEvent event,
      Emitter<SubscriptionState> emit) async {
    final result = await initializeSubscription(NoParam());
    result.fold((failure) {
      emit(InitializeSubscriptionFailure(errorMessage: failure.message));
    }, (value) async {
      emit(InitializeSubscriptionSuccess(response: value));
    });
  }

  Future<void> onGetSubscriptionProducts(GetSubscriptionProductsEvent event,
      Emitter<SubscriptionState> emit) async {
    final param = GetSubscriptionProductsParam(event.productIds);
    final result = await getSubscriptionProducts(param);
    result.fold((failure) {
      emit(GetSubscriptionProductsFailure(errorMessage: failure.message));
    }, (value) async {
      emit(GetSubscriptionProductsSuccess(iapItems: value));
    });
  }

  Future<void> onGetPastPurchases(
      GetPastPurchasesEvent event, Emitter<SubscriptionState> emit) async {
    final result = await getPastPurchases(NoParam());
    result.fold((failure) {
      emit(GetPastPurchasesFailure(errorMessage: failure.message));
    }, (value) async {
      emit(GetPastPurchasesSuccess(purchasedItems: value ?? []));
    });
  }

  Future<void> onPurchaseProductLoading(
      PurchaseSubscriptionProductLoadingEvent event,
      Emitter<SubscriptionState> emit) async {
    if (event.isLoading) {
      emit(PurchaseSubscriptionProductLoading());
    } else {
      emit(PurchaseSubscriptionProductStopLoading());
    }
  }

  Future<void> onPurchaseProduct(PurchaseSubscriptionProductEvent event,
      Emitter<SubscriptionState> emit) async {
    final param =
        PurchaseSubscriptionProductParam(event.productId, event.isUpgrade);
    final result = await purchaseSubscriptionProduct(param);
    result.fold((failure) {
      emit(PurchaseSubscriptionProductStopLoading());
      emit(PurchaseSubscriptionProductFailure(errorMessage: failure.message));
    }, (value) async {
      emit(PurchaseSubscriptionProductSuccess(response: value));
    });
  }

  Future<void> onVerifyReceiptAndroid(
      VerifyReceiptAndroidEvent event, Emitter<SubscriptionState> emit) async {
    emit(VerifyPurchaseAndroidLoading());
    final param = VerifyReceiptAndroidParam(
        event.purchaseReceiptAndroid, event.purchasedItem);
    final result = await verifyReceiptAndroid(param);
    result.fold((failure) {
      emit(PurchaseSubscriptionProductStopLoading());
      emit(VerifyPurchaseAndroidFailure(errorMessage: failure.message));
    }, (value) async {
      emit(VerifyPurchaseAndroidSuccess(verifyReceiptAndroidRes: value));
    });
  }

  Future<void> onVerifyReceiptIOS(
      VerifyReceiptIOSEvent event, Emitter<SubscriptionState> emit) async {
    emit(VerifyPurchaseAndroidLoading());
    final param = VerifyReceiptIOSParam(event.purchaseReceiptIOS);
    final result = await verifyReceiptIOS(param);
    result.fold((failure) {
      emit(PurchaseSubscriptionProductStopLoading());
      emit(VerifyPurchaseIOSFailure(errorMessage: failure.message));
    }, (value) async {
      emit(VerifyPurchaseIOSSuccess(verifyReceiptIOSRes: value));
    });
  }

  Future<void> onCompleteTransaction(
      CompleteTransactionEvent event, Emitter<SubscriptionState> emit) async {
    final param = CompleteTransactionParam(
        purchasedItem: event.purchasedItem,
        transactionId: event.transactionId,
        isConsumable: event.isConsumable);
    final result = await completeTransaction(param);
    result.fold((failure) {
      emit(PurchaseSubscriptionProductStopLoading());
      emit(CompleteTransactionFailure(errorMessage: failure.message));
    }, (value) async {
      emit(CompleteTransactionSuccess(finishMessage: value));
    });
  }

  Future<void> onFinalizeSubscription(
      FinalizeSubscriptionEvent event, Emitter<SubscriptionState> emit) async {
    final result = await finalizeSubscription(NoParam());
    result.fold((failure) {
      emit(FinalizeSubscriptionFailure(errorMessage: failure.message));
    }, (value) async {
      emit(FinalizeSubscriptionSuccess(response: value));
    });
  }

  Future<void> onGetSubscriptionStatus(
      GetSubscriptionStatusEvent event, Emitter<SubscriptionState> emit) async {
    final param = GetSubscriptionStatusParam(event.productId);
    final result = await getSubscriptionStatus(param);
    result.fold((failure) {
      emit(GetSubscriptionStatusFailure(errorMessage: failure.message));
    }, (value) async {
      if (value.productId!.contains(AppConstant.yearly)) {
        emit(GetYearlySubscriptionStatusSuccess(
            subscriptionStateResponse: value));
      } else {
        emit(GetMonthlySubscriptionStatusSuccess(
            subscriptionStateResponse: value));
      }
    });
  }

  Future<void> onCheckSubscriptionReadyStatus(
      CheckSubscriptionReadyStatusEvent event,
      Emitter<SubscriptionState> emit) async {
    final result = await checkSubscriptionReadyStatus(NoParam());
    result.fold((failure) {
      emit(CheckSubscriptionReadyStatusFailure(errorMessage: failure.message));
    }, (value) async {
      emit(CheckSubscriptionReadyStatusSuccess());
    });
  }
}
