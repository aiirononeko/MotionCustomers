import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motion_customers/service/firestore_customize.dart';
import 'package:motion_customers/ui/home_screen/home_screen.dart';
import 'package:motion_customers/view_model/home_view_model.dart';
import 'package:motion_customers/view_model/point_card_view_model.dart';
import 'package:provider/provider.dart';

void main() async {

  // Firebase初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 初回起動時、匿名ユーザー登録
  if (FirebaseAuth.instance.currentUser == null) {
    await FirestoreCustomize.signInAndAddCustomerDocument();
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
