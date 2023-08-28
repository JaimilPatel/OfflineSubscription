import 'package:flutter_inapp_purchase/modules.dart';
import 'package:http/http.dart' as http;
import 'package:offline_subscription/presentation/subscription/model/purchase_receipt_android.dart';

class VerifyReceiptAndroidRes {
  final PurchaseReceiptAndroid purchaseReceiptAndroid;
  final http.Response response;
  final PurchasedItem purchasedItem;
  VerifyReceiptAndroidRes(
      {required this.purchaseReceiptAndroid,
      required this.response,
      required this.purchasedItem});
}
