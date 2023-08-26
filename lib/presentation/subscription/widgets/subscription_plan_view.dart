import 'package:flutter/material.dart';
import 'package:offline_subscription/core/constant/pixel_size.dart';
import 'package:offline_subscription/core/constant/string_constant.dart';
import 'package:offline_subscription/core/constant/text_styles.dart';
import 'package:offline_subscription/util/common_utils.dart';

class SubscriptionPlanView extends StatefulWidget {
  final bool isSelected;
  final String title;
  final String plan;
  final String planSubTitle;
  final int index;
  final Function(int) onTap;
  final bool isPlanDisable;
  const SubscriptionPlanView(
      {Key? key,
      required this.isSelected,
      required this.title,
      required this.plan,
      required this.planSubTitle,
      required this.index,
      required this.onTap,
      this.isPlanDisable = false})
      : super(key: key);

  @override
  State<SubscriptionPlanView> createState() => _SubscriptionPlanViewState();
}

class _SubscriptionPlanViewState extends State<SubscriptionPlanView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _subscriptionPlanView(widget.isSelected, widget.title, widget.plan,
        widget.planSubTitle, widget.index);
  }

  Widget _subscriptionPlanView(bool isSelected, String title, String plan,
          String planSubTitle, int index) =>
      InkWell(
        onTap: widget.isPlanDisable
            ? () {
                CommonUtils.displayToast(
                    context, StringConstant.activeSubscription);
              }
            : () {
                _onPlanViewTap(index);
              },
        child: _circularPlanView(isSelected, title, index, plan),
      );

  void _onPlanViewTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap(_selectedIndex);
  }

  Widget _circularPlanView(
          bool isSelected, String title, int index, String plan) =>
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: isSelected ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(PixelSize.value12)),
        padding: EdgeInsets.all(PixelSize.value15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _planUpperView(title, isSelected),
            _planCenterView(plan),
          ],
        ),
      );

  Widget _planUpperView(String title, bool isSelected) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyles.getH7(
                    Colors.black, FontWeight.w500, FontStyle.normal)
                .copyWith(letterSpacing: 1),
          ),
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_off,
            color: isSelected ? Colors.red : Colors.grey,
          )
        ],
      );

  Widget _planCenterView(String plan) => Padding(
        padding: EdgeInsets.symmetric(vertical: PixelSize.value8),
        child: Text(
          plan,
          style:
              TextStyles.getH4(Colors.black, FontWeight.w600, FontStyle.normal),
        ),
      );
}
