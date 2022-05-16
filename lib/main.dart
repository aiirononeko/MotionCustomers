import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motion_customers/service/firestore_customize.dart';
import 'package:motion_customers/ui/home_screen/home_screen.dart';
import 'package:motion_customers/view_model/home_view_model.dart';
import 'package:motion_customers/view_model/point_card_view_model.dart';
import 'package:provider/provider.dart';

import 'entity/customers.dart';

void main() async {

  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 初回起動時、匿名ユーザー登録
  if (FirebaseAuth.instance.currentUser == null) {
    await FirestoreCustomize.signInAndAddCustomerDocument();
  }

  // ユーザー情報を取得
  Customers user = await FirestoreCustomize.fetchCustomerInfo(FirebaseAuth.instance.currentUser!.uid);

  // プレミアム会員の場合、起動毎にユーザーステータスを確認
  if (user.isPremium) {
    try {
      HttpsCallable verifyReceipt =
      FirebaseFunctions.instanceFor(region: 'asia-northeast1').httpsCallable('verifyUserStatus');
      final HttpsCallableResult result = await verifyReceipt.call();
      print("RESULT CODE: " + result.data["result"].toString());
    } catch (err) {
      print(err);
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PointCardViewModel()),
        // ChangeNotifierProvider(create: (_) => PaymentViewModel())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}
