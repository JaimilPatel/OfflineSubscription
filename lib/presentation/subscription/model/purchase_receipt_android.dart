class PurchaseReceiptAndroid {
  String packageName;
  String productId;
  String productToken;
  String accessToken;
  bool isSubscription;

  PurchaseReceiptAndroid(
      {required this.packageName,
      required this.productId,
      required this.productToken,
      required this.accessToken,
      required this.isSubscription});
}
