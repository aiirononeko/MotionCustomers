import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_customers/ui/login_screen/login_screen.dart';
import 'package:motion_customers/ui/register_screen/register_screen.dart';

import '../../service/hex_color.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.2,
          ),
          SizedBox(
            width: width * 0.4,
            height: height * 0.4,
            child: SvgPicture.asset('images/MotionLogoSub.svg'),
          ),
          SizedBox(
            height: height * 0.2,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: width * 0.01),
                  child: ElevatedButton(
                    child: Text(
                        'LOG IN',
                      style: TextStyle(
                        color: HexColor('FC2951')
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const LoginScreen()
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 0.45, height * 0.065),
                      primary: HexColor('FFFFFF'), // ボタンの背景色
                      side: BorderSide(
                        color: HexColor('FC2951'), //色
                        width: 1, //太さ
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.01),
                  child: ElevatedButton(
                    child: const Text('REGISTER'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const RegisterScreen()
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 0.45, height * 0.065),
                      primary: HexColor('FC2951'), // ボタンの背景色
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
