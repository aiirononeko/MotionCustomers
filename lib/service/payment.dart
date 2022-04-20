import 'package:in_app_purchase/in_app_purchase.dart';

class Payment {

  final InAppPurchase _connection = InAppPurchase.instance;

  /// サブスクアイテムの取得を行う
  /// 課金ページを開いた時に実行する
  Future<ProductDetails?> getSubscriptionItemInfo() async {

    final List<String> _productId = ["motion_subscription"];

    // ストア情報が有効か判断
    final bool isAvailable = await _connection.isAvailable();

    if (!isAvailable) {
      return null;
    }

    // サブスクの商品情報を取得する
    ProductDetailsResponse productDetailResponse =
      await _connection.queryProductDetails(_productId.toSet());

    if (productDetailResponse.error != null) {
      return null;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      return null;
    }

    // 課金プランは1つと仮定した実装です
    if (productDetailResponse.productDetails.length == 1 &&
        productDetailResponse.productDetails.first.id == _productId.first) {
      return productDetailResponse.productDetails.first;
    }

    return null;
  }

  /// コーヒーチケットアイテムの取得を行う
  /// 課金ページを開いた時に実行する
  Future<ProductDetails?> getCoffeeTicketItemInfo() async {

    final List<String> _productId = ["motion_coffee_ticket"];

    // ストア情報が有効か判断
    final bool isAvailable = await _connection.isAvailable();

    if (!isAvailable) {
      return null;
    }

    // サブスクの商品情報を取得する
    ProductDetailsResponse productDetailResponse =
    await _connection.queryProductDetails(_productId.toSet());

    if (productDetailResponse.error != null) {
      return null;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      return null;
    }

    // 課金プランは1つと仮定した実装です
    if (productDetailResponse.productDetails.length == 1 &&
        productDetailResponse.productDetails.first.id == _productId.first) {
      return productDetailResponse.productDetails.first;
    }

    return null;
  }
}
