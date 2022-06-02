import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../entity/customers.dart';

class FirestoreService {

  final FirebaseFirestore instance = FirebaseFirestore.instance;

  /// Firestoreからカスタマー情報を取得して返却します.
  Future<Customers> fetchCustomerInfo(String uid) async {

    // Customersコレクションからデータを取得
    final snapshot = await instance.collection('Customers').doc(uid).get();

    if (snapshot.exists) {
      // データがあればエンティティクラスに値を詰めて返却
      return Customers.fromMap(snapshot.data());
    } else {
      // 実質何もしない
      throw Error();
    }
  }

  /// Firestoreにカスタマー情報を作成します.
  Future<void> createCustomerInfo(String email, String uid) async {
    // Customersコレクションにデータを書き込み
    await instance.collection('Customers').doc(uid).set({
      'uid': uid,
      'points': 0,
      'coffeeTickets': 0,
      'isPremium': false,
      'email': email,
    });
  }

  /// Firestoreに退会ユーザー情報を登録します.
  Future<void> createWithdrawCustomer(String uid) async {
    // WithdrawCustomersコレクションにデータを書き込み
    await instance.collection("WithdrawCustomers").doc(uid).set({
      'uid': uid
    });
  }

  /// Firestoreにサブスクリプションのチェックアウトセッション情報を登録します.
  Future<DocumentReference> createCheckoutSessionsForSubscription(BuildContext context, String uid, String priceId) async {
    return await instance.collection('customers').doc(uid).collection('checkout_sessions').add({
      "price": priceId,
      "success_url": "https://motion-dev-d0877.web.app",
      "cancel_url": "https://motion-dev-d0877.web.app",
    });
  }

  /// Firestoreにコーヒーチケットのチェックアウトセッション情報を登録します.
  Future<DocumentReference> createCheckoutSessionsForCoffeeTicket(BuildContext context, String uid, String priceId) async {
    return await instance.collection('customers').doc(uid).collection('checkout_sessions').add({
      "price": priceId,
      "success_url": "https://motion-dev-d0877.web.app",
      "cancel_url": "https://motion-dev-d0877.web.app",
      "mode": "payment",
    });
  }
}
