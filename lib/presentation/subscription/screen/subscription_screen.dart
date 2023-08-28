import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:offline_subscription/core/constant/app_constant.dart';
import 'package:offline_subscription/core/constant/color_constant.dart';
import 'package:offline_subscription/core/constant/param_constant.dart';
import 'package:offline_subscription/core/constant/pixel_size.dart';
import 'package:offline_subscription/core/constant/screen_size_config.dart';
import 'package:offline_subscription/core/constant/string_constant.dart';
import 'package:offline_subscription/core/constant/text_styles.dart';
import 'package:offline_subscription/core/sharepref_helper.dart';
import 'package:offline_subscription/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:offline_subscription/presentation/subscription/bloc/subscription_event.dart';
import 'package:offline_subscription/presentation/subscription/bloc/subscription_state.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_android.dart';
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_ios.dart';
import 'package:offline_subscription/presentation/subscription/screen/subscription_page.dart';
import 'package:offline_subscription/presentation/subscription/widgets/subscription_plan_view.dart';
import 'package:offline_subscription/reusable_widgets/progress_loading_indicator.dart';
import 'package:offline_subscription/reusable_widgets/reusable_button.dart';
import 'package:offline_subscription/util/common_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import "package:http/http.dart" as http;

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedIndex = 0;
  SubscriptionBloc? _subscriptionBloc;
  List<IAPItem> _subscriptionItems = [];
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  final List<PurchasedItem> _pastPurchases = [];
  final ScrollController _scrollController = ScrollController();
  String accessToken = "";
  bool _isRestoredEnable = false;
  bool _isNextEnable = false;
  bool _isProgressDone = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      _subscriptionBloc = BlocProvider.of<SubscriptionBloc>(context);
      _subscriptionBloc?.add(InitializeSubscriptionEvent());
      await _getDetailsToVerifyPurchaseOnAndroid();
    });
  }

  Future _getDetailsToVerifyPurchaseOnAndroid() async {
    if (Platform.isAndroid) {
      AccessCredentials credentials = await obtainCredentials();
      setState(() {
        accessToken = credentials.accessToken.data;
      });
    }
  }

  Future<AccessCredentials> obtainCredentials() async {
    var accountCredentials = ServiceAccountCredentials.fromJson({
      ParamConstant.privateKeyId: "<private key id from secure space>",
      ParamConstant.privateKey: "<private key from secure space>",
      ParamConstant.clientEmail: "<client email from secure space>",
      ParamConstant.clientId: "<client id from secure space>",
      ParamConstant.type: "<type from secure space>",
    });
    var scopes = [AppConstant.verifyingScope];

    var client = http.Client();
    AccessCredentials credentials =
        await obtainAccessCredentialsViaServiceAccount(
            accountCredentials, scopes, client);

    client.close();
    return credentials;
  }

  @override
  void dispose() async {
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription?.cancel();
      _purchaseUpdatedSubscription = null;
    }
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription?.cancel();
      _purchaseErrorSubscription = null;
    }
    _subscriptionBloc?.add(FinalizeSubscriptionEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return _subscriptionView(context);
  }

  Widget _subscriptionView(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
            listener: (context, state) {
              _subscriptionStateWiseMethod(context, state);
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: PixelSize.value30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _chooseSubscriptionView(),
                    _extraHeight(context, PixelSize.value15),
                    if (_subscriptionItems.isNotEmpty && _isProgressDone)
                      _subscriptionPlanList(context, state)
                    else
                      _indicatingLoader(),
                    _extraHeight(context, PixelSize.value15),
                    _nextBtn(context, state),
                    _restoreBtn(context),
                  ],
                ),
              );
            },
          ),
        ),
      );

  Widget _chooseSubscriptionView() => Padding(
        padding:
            EdgeInsets.only(top: PixelSize.value10, bottom: PixelSize.value5),
        child: Text(
          StringConstant.subscriptionPlans,
          style:
              TextStyles.getH0(Colors.black, FontWeight.w600, FontStyle.normal),
        ),
      );

  Widget _extraHeight(BuildContext context, double value) =>
      SizedBox(height: ScreenSizeConfig.getScaledValue(value, context));

  Widget _subscriptionPlanList(BuildContext context, SubscriptionState state) =>
      ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: index == 0
                  ? EdgeInsets.only(bottom: PixelSize.value20)
                  : EdgeInsets.zero,
              child: SubscriptionPlanView(
                  isSelected: _selectedIndex == (index + 1),
                  title: Platform.isIOS
                      ? _subscriptionItems[index].title ?? ""
                      : _subscriptionItems[index].title?.substring(0, 12) ?? "",
                  plan: ((_subscriptionItems[index].localizedPrice ?? "")
                          .toUpperCase()) +
                      _getRatePerMonthYear(index),
                  planSubTitle:
                      ((_subscriptionItems[index].localizedPrice ?? "")
                              .toUpperCase()) +
                          _getPerMonthYear(index),
                  index: (index + 1),
                  isPlanDisable: _isRestoredEnable,
                  onTap: (index) {
                    if (state is PurchaseSubscriptionProductLoading == false) {
                      _onPlanViewTap(index);
                    }
                  }),
            );
          },
          itemCount: _subscriptionItems.length);

  String _getRatePerMonthYear(int index) =>
      index == 0 ? StringConstant.slashMonth : StringConstant.slashYear;

  String _getPerMonthYear(int index) =>
      index == 0 ? StringConstant.perMonth : StringConstant.perYear;

  Widget _indicatingLoader() => SizedBox(
        height: ScreenSizeConfig.screenHeight * 0.3,
        child: const Center(child: ProgressLoadingIndicator()),
      );

  Widget _nextBtn(BuildContext context, SubscriptionState state) {
    if (state is PurchaseSubscriptionProductLoading) {
      return _btnWithLoading(context);
    } else {
      return _btnWithLabel(context);
    }
  }

  Widget _btnWithLoading(BuildContext context) => Container(
        width: ScreenSizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(
            horizontal: PixelSize.value10, vertical: PixelSize.value25),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  PixelSize.value10,
                ),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                  horizontal: PixelSize.value40, vertical: PixelSize.value16),
            ),
          ),
          onPressed: null,
          child: const ProgressLoadingIndicator(colors: [Colors.white]),
        ),
      );

  Widget _btnWithLabel(BuildContext context) => Container(
        width: ScreenSizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(
            horizontal: PixelSize.value10, vertical: PixelSize.value25),
        child: ReusableButton(
            text: StringConstant.next,
            onPressed: _selectedIndex != 0 && _isNextEnable == true
                ? () {
                    _purchaseSubscriptionProduct(context);
                  }
                : null,
            textColor: _selectedIndex != 0 && _isNextEnable == true
                ? Colors.white
                : ColorConstant.greyColor,
            backgroundColor: _selectedIndex != 0 && _isNextEnable == true
                ? Colors.red
                : ColorConstant.whiteColor),
      );

  Widget _restoreBtn(BuildContext context) => Container(
        width: ScreenSizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(horizontal: PixelSize.value10),
        child: ReusableButton(
            text: StringConstant.restore,
            onPressed: _isRestoredEnable
                ? () {
                    _onRestoreTap(context);
                  }
                : null,
            textColor:
                _isRestoredEnable ? Colors.white : ColorConstant.greyColor,
            backgroundColor:
                _isRestoredEnable ? Colors.red : ColorConstant.whiteColor),
      );

  void _onRestoreTap(BuildContext context) {
    //You can save plan detail in your preference
    CommonUtils.displayToast(context, StringConstant.restoredPlan);
  }

  void _subscriptionStateWiseMethod(
      BuildContext context, SubscriptionState state) async {
    if (state is InitializeSubscriptionSuccess) {
      _subscriptionBloc?.add(CheckSubscriptionReadyStatusEvent());
    } else if (state is InitializeSubscriptionFailure) {
      _subscriptionBloc?.add(InitializeSubscriptionEvent());
    } else if (state is CheckSubscriptionReadyStatusSuccess) {
      _getSubscriptionProducts();
    } else if (state is CheckSubscriptionReadyStatusFailure) {
      _subscriptionBloc?.add(InitializeSubscriptionEvent());
    } else if (state is GetSubscriptionProductsSuccess) {
      _updateSubscriptionProductAndGetPastPurchase(state);
    } else if (state is GetSubscriptionProductsFailure) {
      CommonUtils.displayToast(context, state.errorMessage);
    } else if (state is GetPastPurchasesSuccess) {
      _addPurchaseItems(state);
    } else if (state is GetPastPurchasesFailure) {
      CommonUtils.displayToast(context, state.errorMessage);
    } else if (state is PurchaseSubscriptionProductFailure) {
      debugPrint(state.errorMessage);
    } else if (state is VerifyPurchaseAndroidSuccess) {
      _completeAndroidTransaction(state);
    } else if (state is VerifyPurchaseAndroidFailure) {
      CommonUtils.displayToast(context, state.errorMessage);
    } else if (state is VerifyPurchaseIOSSuccess) {
      _completeIOSTransaction(state);
    } else if (state is VerifyPurchaseIOSFailure) {
      CommonUtils.displayToast(context, state.errorMessage);
    } else if (state is CompleteTransactionSuccess) {
      _subscriptionBloc?.add(
          const PurchaseSubscriptionProductLoadingEvent(isLoading: false));
      if (ModalRoute.of(context)?.settings.name == SubscriptionPage.tag ||
          ModalRoute.of(context)?.settings.name == "/") {
        if (Platform.isIOS) {
          if (SharedPreferenceHelper.getBottomSheetShown() == true) {
            _showBottomSheet(context);
          }
        } else {
          _showBottomSheet(context);
        }
      }
    } else if (state is CompleteTransactionFailure) {
      CommonUtils.displayToast(context, state.errorMessage);
    } else if (state is PurchaseSubscriptionProductStopLoading) {
      if (Platform.isIOS) {
        SharedPreferenceHelper.setBottomSheetShown(false);
      }
    } else {
      debugPrint("Error not required");
    }
  }

  void _getSubscriptionProducts() async {
    await _listenPurchaseStreams();
    _subscriptionBloc?.add(const GetSubscriptionProductsEvent(
        productIds: [AppConstant.monthlyPlan, AppConstant.yearlyPlan]));
    await FlutterInappPurchase.instance.initialize();
    bool isMonthlyActive = await FlutterInappPurchase.instance
        .checkSubscribed(sku: AppConstant.monthlyPlan);
    bool isYearlyActive = await FlutterInappPurchase.instance
        .checkSubscribed(sku: AppConstant.yearlyPlan);
    if (isMonthlyActive || isYearlyActive) {
      setState(() {
        _isRestoredEnable = true;
      });
    }
    setState(() {
      _isNextEnable = !_isRestoredEnable;
      _isProgressDone = true;
    });
    if (Platform.isIOS) {
      if (_isRestoredEnable == true) {
        SharedPreferenceHelper.setBottomSheetShown(false);
      }
    }
  }

  void _updateSubscriptionProductAndGetPastPurchase(
      GetSubscriptionProductsSuccess state) {
    setState(() {
      if (state.iapItems.isNotEmpty) {
        _subscriptionItems = List.from(state.iapItems);
      } else {
        _subscriptionItems = [];
      }
    });
  }

  void _addPurchaseItems(GetPastPurchasesSuccess state) {
    for (var item in state.purchasedItems) {
      setState(() {
        _pastPurchases.add(item);
      });
    }
  }

  void _completeAndroidTransaction(VerifyPurchaseAndroidSuccess state) {
    if (state.verifyReceiptAndroidRes.response.statusCode == 200) {
      if (Platform.isAndroid) {
        _subscriptionBloc?.add(CompleteTransactionEvent(
            purchasedItem: state.verifyReceiptAndroidRes.purchasedItem,
            isConsumable: false));
      }
    }
  }

  void _completeIOSTransaction(VerifyPurchaseIOSSuccess state) {
    if (state.verifyReceiptIOSRes.response.statusCode == 200) {
      if (Platform.isIOS) {
        _subscriptionBloc?.add(CompleteTransactionEvent(
            transactionId: state.verifyReceiptIOSRes.purchaseReceiptIOS
                    .receiptBody[ParamConstant.transactionId] ??
                ""));
      }
    }
  }

  Future<void> _listenPurchaseStreams() async {
    if (!mounted) return;
    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((error) {
      _subscriptionBloc?.add(
          const PurchaseSubscriptionProductLoadingEvent(isLoading: false));
    });
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      if (productItem != null) {
        if (Platform.isIOS) {
          if (productItem.transactionStateIOS == TransactionState.purchasing) {
            debugPrint('purchase:purchasing');
          } else if (productItem.transactionStateIOS ==
              TransactionState.failed) {
            debugPrint('purchase-error:');
          } else if (productItem.transactionStateIOS ==
              TransactionState.purchased) {
            debugPrint('purchase-purchased:');
            _verifyIOSReceipt(productItem);
          } else if (productItem.transactionStateIOS ==
              TransactionState.restored) {
            debugPrint('purchase-restored:');
          } else if (productItem.transactionStateIOS ==
              TransactionState.deferred) {
            debugPrint('A transaction that is in the queue');
          } else {
            debugPrint('not required');
          }
        } else {
          if (productItem.purchaseStateAndroid == PurchaseState.pending) {
            debugPrint('purchase:pending');
          } else if (productItem.purchaseStateAndroid ==
              PurchaseState.unspecified) {
            debugPrint('purchase-unspecified:');
          } else if (productItem.purchaseStateAndroid ==
              PurchaseState.purchased) {
            debugPrint('purchase-purchased:');
            _verifyAndroidReceipt(productItem);
          } else {
            debugPrint('purchase-failed:');
          }
        }
      }
    }, onDone: () {
      _purchaseUpdatedSubscription?.cancel();
    }, onError: (purchaseError) {
      _subscriptionBloc?.add(
          const PurchaseSubscriptionProductLoadingEvent(isLoading: false));
    });
  }

  void _verifyIOSReceipt(PurchasedItem productItem) {
    PurchaseReceiptIOS purchaseReceiptIOS = PurchaseReceiptIOS(receiptBody: {
      ParamConstant.receiptData: productItem.transactionReceipt ?? "",
      ParamConstant.password: "<app-specific-shared-secret>"
    }, isTest: false);
    _subscriptionBloc
        ?.add(VerifyReceiptIOSEvent(purchaseReceiptIOS: purchaseReceiptIOS));
  }

  void _verifyAndroidReceipt(PurchasedItem productItem) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    PurchaseReceiptAndroid purchaseReceiptAndroid = PurchaseReceiptAndroid(
        packageName: packageInfo.packageName,
        productId: productItem.productId ?? "",
        productToken: productItem.purchaseToken ?? "",
        accessToken: accessToken,
        isSubscription: true);
    _subscriptionBloc?.add(VerifyReceiptAndroidEvent(
        purchaseReceiptAndroid: purchaseReceiptAndroid,
        purchasedItem: productItem));
  }

  void _showBottomSheet(BuildContext context) {
    if (Platform.isIOS) {
      SharedPreferenceHelper.setBottomSheetShown(false);
    }
    CommonUtils.displayToast(context, StringConstant.purchaseSuccessfully);
  }

  void _purchaseSubscriptionProduct(BuildContext context) {
    _subscriptionBloc
        ?.add(const PurchaseSubscriptionProductLoadingEvent(isLoading: true));
    _subscriptionBloc?.add(PurchaseSubscriptionProductEvent(
        productId: _subscriptionItems[_selectedIndex - 1].productId ?? "",
        isUpgrade: false));
    if (Platform.isIOS) {
      SharedPreferenceHelper.setBottomSheetShown(true);
    }
  }

  void _onPlanViewTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
