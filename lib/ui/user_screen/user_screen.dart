import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_customers/service/firestore_customize.dart';
import 'package:motion_customers/ui/first_screen/first_screen.dart';
import 'package:provider/provider.dart';

import '../../service/hex_color.dart';
import '../../view_model/user_view_model.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 顧客情報を取得してエンティティにセット
    Provider.of<UserViewModel>(context).init();

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.1, height * 0.02, width * 0.1, 0),
      child: Column(
        children: [
          SizedBox(
              child: SvgPicture.asset("images/MotionLogoMain.svg")
          ),
          Text(
              "ID: ${context.read<UserViewModel>().customer.uid}"
          ),
          ElevatedButton(
            child: const Text('LOGOUT'),
            onPressed: () async {
                try {

                  // ログアウト
                  await FirebaseAuth.instance.signOut();

                  // First画面に遷移
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const FirstScreen()
                  ));

                } catch (_) {}
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(width * 0.45, height * 0.065),
              primary: HexColor('FC2951'), // ボタンの背景色
            ),
          ),
          ElevatedButton(
            child: const Text('退会'),
            onPressed: () async {
              try {

                String uid = FirebaseAuth.instance.currentUser!.uid;

                // 退会処理
                // UIDをFirestoreに登録(登録をトリガーにCloudFunctionが走る)
                await FirestoreCustomize.createWithdrawCustomer(uid);

                // 念の為サインアウト
                if (FirebaseAuth.instance.currentUser != null) {
                  await FirebaseAuth.instance.signOut();
                }

                // First画面に遷移
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const FirstScreen()
                ));

              } catch (_) {}
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(width * 0.45, height * 0.065),
              primary: HexColor('FC2951'), // ボタンの背景色
            ),
          ),
        ],
      )
    );
  }
}
