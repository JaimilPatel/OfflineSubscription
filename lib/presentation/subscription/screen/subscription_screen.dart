import 'dart:io';
import 'package:flutter/material.dart';
import 'package:offline_subscription/core/constant/pixel_size.dart';
import 'package:offline_subscription/core/constant/screen_size_config.dart';
import 'package:offline_subscription/core/constant/text_styles.dart';
import 'package:offline_subscription/presentation/subscription/model/subscription_item.dart';
import 'package:offline_subscription/presentation/subscription/widgets/subscription_plan_view.dart';
import 'package:offline_subscription/reusable_widgets/progress_loading_indicator.dart';
import 'package:offline_subscription/reusable_widgets/reusable_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedIndex = 0;
  final List<SubscriptionItem> _subscriptionItems = [
    SubscriptionItem(
        title: "Monthly Plan",
        localizedPrice: "1450.00",
        productId: "com.jp.offlinesubscription.monthly"),
    SubscriptionItem(
        title: "Yearly Plan",
        localizedPrice: "11500.00",
        productId: "com.jp.offlinesubscription.yearly"),
  ];
  final ScrollController _scrollController = ScrollController();
  final bool _isRestoredEnable = false;
  bool _isNextEnable = false;
  final bool _isProgressDone = true;

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return _subscriptionView(context);
  }

  Widget _subscriptionView(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: PixelSize.value30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _chooseSubscriptionView(),
                  _extraHeight(context, PixelSize.value15),
                  if (_subscriptionItems.isNotEmpty && _isProgressDone)
                    _subscriptionPlanList(context)
                  else
                    _indicatingLoader(),
                  _nextBtn(context),
                  _restoreBtn(context),
                ],
              ),
            )),
      );

  Widget _chooseSubscriptionView() => Padding(
        padding:
            EdgeInsets.only(top: PixelSize.value10, bottom: PixelSize.value5),
        child: Text(
          "Choose Subscription Plan",
          style:
              TextStyles.getH0(Colors.black, FontWeight.w600, FontStyle.normal),
        ),
      );

  Widget _extraHeight(BuildContext context, double value) =>
      SizedBox(height: ScreenSizeConfig.getScaledValue(value, context));

  Widget _subscriptionPlanList(BuildContext context) => ListView.builder(
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
              planSubTitle: ((_subscriptionItems[index].localizedPrice ?? "")
                      .toUpperCase()) +
                  _getPerMonthYear(index),
              index: (index + 1),
              isPlanDisable: _isRestoredEnable,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  _isNextEnable = true;
                });
              }),
        );
      },
      itemCount: _subscriptionItems.length);

  String _getRatePerMonthYear(int index) => index == 0 ? "/Month" : "/Year";

  String _getPerMonthYear(int index) => index == 0 ? " per month" : " per year";

  Widget _indicatingLoader() => Center(
        child: SizedBox(
          height: ScreenSizeConfig.screenHeight * 0.3,
          child: const ProgressLoadingIndicator(),
        ),
      );

  Widget _nextBtn(BuildContext context) {
    return _btnWithLabel(context);
  }

  Widget _btnWithLabel(BuildContext context) => Container(
        width: ScreenSizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(
            horizontal: PixelSize.value10, vertical: PixelSize.value25),
        child: ReusableButton(
            text: "Next",
            onPressed: _selectedIndex != 0 && _isNextEnable == true
                ? () {
                    //TODO Tap Event To Purchase Plan
                  }
                : null,
            textColor: _selectedIndex != 0 && _isNextEnable == true
                ? Colors.white
                : const Color(0xFF777777),
            backgroundColor: _selectedIndex != 0 && _isNextEnable == true
                ? Colors.red
                : const Color(0xFFE3E3E3)),
      );

  Widget _restoreBtn(BuildContext context) => Container(
        width: ScreenSizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(horizontal: PixelSize.value10),
        child: ReusableButton(
            text: "Restore",
            onPressed: _isRestoredEnable
                ? () {
                    //TODO Restore Tap Event
                  }
                : null,
            textColor:
                _isRestoredEnable ? Colors.white : const Color(0xFF777777),
            backgroundColor:
                _isRestoredEnable ? Colors.red : const Color(0xFFE3E3E3)),
      );
}
