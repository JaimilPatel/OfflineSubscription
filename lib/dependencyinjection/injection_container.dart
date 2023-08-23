import 'package:get_it/get_it.dart';
import 'package:offline_subscription/data/datasources/subscription_datasource.dart';
import 'package:offline_subscription/data/repositories/subscription_repository.dart';
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
import 'package:offline_subscription/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Subscription
  serviceLocator.registerFactory(() => SubscriptionBloc(
      initializeSubscription: serviceLocator(),
      getSubscriptionProducts: serviceLocator(),
      getPastPurchases: serviceLocator(),
      purchaseSubscriptionProduct: serviceLocator(),
      verifyReceiptAndroid: serviceLocator(),
      verifyReceiptIOS: serviceLocator(),
      completeTransaction: serviceLocator(),
      finalizeSubscription: serviceLocator(),
      getSubscriptionStatus: serviceLocator(),
      checkSubscriptionReadyStatus: serviceLocator()));
  serviceLocator
      .registerFactory(() => InitializeSubscription(serviceLocator()));
  serviceLocator
      .registerFactory(() => GetSubscriptionProducts(serviceLocator()));
  serviceLocator.registerFactory(() => GetPastPurchases(serviceLocator()));
  serviceLocator
      .registerFactory(() => PurchaseSubscriptionProduct(serviceLocator()));
  serviceLocator.registerFactory(() => VerifyReceiptAndroid(serviceLocator()));
  serviceLocator.registerFactory(() => VerifyReceiptIOS(serviceLocator()));
  serviceLocator.registerFactory(() => CompleteTransaction(serviceLocator()));
  serviceLocator.registerFactory(() => FinalizeSubscription(serviceLocator()));
  serviceLocator.registerFactory(() => GetSubscriptionStatus(serviceLocator()));
  serviceLocator
      .registerFactory(() => CheckSubscriptionReadyStatus(serviceLocator()));
  serviceLocator.registerFactory<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(serviceLocator()));
  serviceLocator.registerFactory<SubscriptionDataSource>(
      () => SubscriptionDataSourceImpl());

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => preferences);
}
