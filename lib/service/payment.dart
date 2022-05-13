import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:motion_customers/service/firestore_customize.dart';

import '../entity/customers.dart';

class Payment {
  Payment() : super() {

    // 課金処理を監視する
    Stream purchaseUpdated = _connection.purchaseStream;

    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
    }) as StreamSubscription<List<PurchaseDetails>>;
  }

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _connection = InAppPurchase.instance;

  /// ストア情報の初期化を行う
  Future _initStoreStatus() async {
    // 省略
  }

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

  /// 消耗型アイテムを購入する
  Future<void> buyCoffeeTicket(ProductDetails product) async {

    try {
      PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: null
      );
      await _connection.buyConsumable(purchaseParam: purchaseParam);
    } catch (err) {
      // TODO
    }
  }

  /// サブスクリプションアイテムを購入する
  Future<void> buySubscription(ProductDetails product) async {

    try {
      PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: null,
      );
      await _connection.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (err) {
      // TODO
    }
  }

  /// CloudFunctions経由でレシート検証, 期限検証, (検証成功であれば)Firestoreへレシート登録を行う
  Future<int> _verifyPurchase(String data) async {

    // uid取得
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      HttpsCallable verifyReceipt =
          FirebaseFunctions.instanceFor(region: 'asia-northeast1').httpsCallable('VerifyReceipt');
      final HttpsCallableResult result = await verifyReceipt.call(
          {
            'uid': uid,
            'data': data
          }
      );

      print("Verify Purchase RESULT: " + result.data.toString());

      if (result.data["code"] == 200) {
        return PaymentConst.SUCCESS;
      } else {
        return PaymentConst.UNEXPECTED_ERROR;
      }
    } catch (_) {
      return PaymentConst.UNEXPECTED_ERROR;
    }
  }

  /// 購入処理のリスナー
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {

    if (purchaseDetailsList.isEmpty) {
      return;
    }

    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {

      // PurchaseStatus.pending
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("pending");
      } else {

        // PurchaseStatus.error
        if (purchaseDetails.status == PurchaseStatus.error) {
          // TODO
          print("error");
        }

        // PurchaseStatus.purchased
        else if (purchaseDetails.status == PurchaseStatus.purchased) {
          final result = await _verifyPurchase(purchaseDetails.verificationData.serverVerificationData);
          if (result == PaymentConst.SUCCESS) {

            // uid取得
            String? uid = FirebaseAuth.instance.currentUser?.uid;
            if (purchaseDetails.productID == "motion_coffee_ticket") {
              Customers customer = await FirestoreCustomize.fetchCustomerInfo(uid!);
              FirestoreCustomize.updateCoffeeTicketsAmount(uid!, int.parse(customer.coffeeTickets)); /// コーヒーチケット追加
              print("add coffee tickets");
            } else if (purchaseDetails.productID == "motion_subscription") {
              FirestoreCustomize.updatePremiumAccount(uid!); /// サブスクリプション反映
              print("changed user status");
            }

            print("success");
          }
        }

        // PurchaseStatus.restored
        else if (purchaseDetails.status == PurchaseStatus.restored) {
          final result = await _verifyPurchase(purchaseDetails.verificationData.serverVerificationData);
          if (result == PaymentConst.SUCCESS) {

            // uid取得
            String? uid = FirebaseAuth.instance.currentUser?.uid;
            if (purchaseDetails.productID == "motion_coffee_ticket") {
              Customers customer = await FirestoreCustomize.fetchCustomerInfo(uid!);
              FirestoreCustomize.updateCoffeeTicketsAmount(uid!, int.parse(customer.coffeeTickets)); /// コーヒーチケット追加
              print("add coffee tickets");
            } else if (purchaseDetails.productID == "motion_subscription") {
              FirestoreCustomize.updatePremiumAccount(uid!); /// サブスクリプション反映
              print("changed user status");
            }

            print("restored");
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _connection.completePurchase(purchaseDetails);
          print("completed");
        }

        showPendingUI(false);
      }
    });
  }

  /// 画面をロックする
  void showPendingUI(bool pending) {
    // TODO
  }
}

class PaymentConst {
  static const String result = 'result';
  static const SUCCESS = 0; // 成功 (期限内)
  static const EXPIRED = 1; // 期限切れ
  static const DOCUMENT_NOT_FOUND = 2; // Firestoreにドキュメントなし
  static const NO_AUTH = 3; // 認証情報なし
  static const INVALID_RECEIPT = 4; // レシート情報が不正です
  static const ALREADY_EXIST = 5; // 同じトランザクションが存在している
  static const UNEXPECTED_ERROR = 99; // 不明なエラー
}