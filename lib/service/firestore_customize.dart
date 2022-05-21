import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/customers.dart';

class FirestoreCustomize {

  static final FirebaseFirestore instance = FirebaseFirestore.instance;

  /// Firestoreからカスタマー情報を取得して返却します.
  static Future<Customers> fetchCustomerInfo(String uid) async {

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
  static Future<void> createCustomerInfo(String email, String uid) async {
    // Customersコレクションにデータを書き込み
    await instance.collection('Customers').doc(uid).set({
      'uid': uid,
      'points': 0,
      'coffeeTickets': 0,
      'isPremium': false,
      'email': email,
    });
  }

  /// Firestoreのカスタマー情報を更新します(サブスクの購入).
  static Future<void> updatePremiumAccount(String uid) async {
    await instance.collection('Customers').doc(uid).update({
      'isPremium': true
    });
  }

  /// Firestoreのカスタマー情報を更新します(コーヒーチケットの購入).
  static Future<void> updateCoffeeTicketsAmount(String uid, int coffeeTickets) async {
    await instance.collection('Customers').doc(uid).update({
      'coffeeTickets': coffeeTickets+=11
    });
  }


  /// Firestoreに退会ユーザー情報を登録します.
  static Future<void> createWithdrawCustomer(String uid) async {
    // WithdrawCustomersコレクションにデータを書き込み
    await instance.collection("WithdrawCustomers").doc(uid).set({
      'uid': uid
    });
  }
}
