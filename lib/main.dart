import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motion_customers/service/firestore_service.dart';
import 'package:motion_customers/ui/first_screen/first_screen.dart';
import 'package:motion_customers/ui/home_screen/home_screen.dart';
import 'package:motion_customers/view_model/home_view_model.dart';
import 'package:motion_customers/view_model/point_card_view_model.dart';
import 'package:motion_customers/view_model/register_view_model.dart';
import 'package:motion_customers/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

import 'entity/customers.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化
  await Firebase.initializeApp();

  // 認証情報がある場合
  if (FirebaseAuth.instance.currentUser != null) {

    // ユーザー情報を取得
    Customers user = await FirestoreService().fetchCustomerInfo(FirebaseAuth.instance.currentUser!.uid);

    // プレミアム会員の場合、起動毎にユーザーステータスを確認
    if (user.isPremium) {
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PointCardViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 認証情報がない場合、ログイン・ユーザー登録画面に遷移する
    if (FirebaseAuth.instance.currentUser == null) {
      return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: FirstScreen()
      );
    } else {
      return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen()
      );
    }
  }
}
