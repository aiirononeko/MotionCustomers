import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entity/customers.dart';

class FirestoreCustomize {

  static final FirebaseFirestore instance = FirebaseFirestore.instance;

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

  static Future<void> signInAndAddCustomerDocument() async {

    // 匿名ユーザーとしてログイン
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();

    final snapshot = await instance.collection('Customers').doc(userCredential.user!.uid).get();

    // 該当するドキュメントが存在しない場合
    if (!snapshot.exists) {
      // Customersコレクションにデータを書き込み
      await instance.collection('Customers').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'points': 0,
        'coffeeTickets': 0,
        'isPremium': false
      });
    }
  }

  static Future<void> updatePremiumAccount(String uid) async {

    final snapshot = await instance.collection('Customers').doc(uid).get();

    if (!snapshot.data()?['isPremium']) {
      await instance.collection('Customers').doc(uid).update({
        'isPremium': true
      });
    } else {
      // TODO 後ほどエラーハンドリングを実装
      print('このユーザーはすでにプレミアム会員です');
    }
  }

  static Future<void> updateCoffeeTicketsAmount(String uid, int coffeeTickets) async {

    await instance.collection('Customers').doc(uid).update({
      'coffeeTickets': coffeeTickets+=10
    });
  }
}
