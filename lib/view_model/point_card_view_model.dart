import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motion_customers/service/firestore_service.dart';
import 'package:motion_customers/service/hex_color.dart';

import '../entity/customers.dart';

class PointCardViewModel extends ChangeNotifier {

  Customers _customer = Customers();

  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  Customers get customer => _customer;
  String get uid => _uid;

  Future<void> init() async {
    _customer = await FirestoreService().fetchCustomerInfo(_uid);
    notifyListeners();
  }

  Color checkIsPremiumColor() {
    if (_customer.isPremium) {
      // プレミアム会員の場合、イエローを返す
      return Colors.black;
    } else {
      // ベーシック会員の場合、ブラックを返す
      return Colors.white;
    }
  }
  
  Color checkIsPremiumCardColor() {
    if (_customer.isPremium) {
      // プレミアム会員の場合
      return HexColor("FAFF00");
    } else {
      // ベーシック会員の場合
      return HexColor("FC2951");
    }
  }

  String checkIsPremiumString() {
    if (_customer.isPremium) {
      // プレミアム会員の場合
      return 'Premium Member';
    } else {
      // ベーシック会員の場合
      return 'Basic Member';
    }
  }

  Widget checkIsPremiumCard() {
    if (_customer.isPremium) {
      // プレミアム会員の場合
      return SvgPicture.asset('images/id_card.svg');
    } else {
      // ベーシック会員の場合
      return SvgPicture.asset('images/id_card_basic.svg');
    }
  }

  SvgPicture checkIsPremiumLogo() {
    if (_customer.isPremium) {
      // プレミアム会員の場合
      return SvgPicture.asset("images/MotionLogoPremium.svg");
    } else {
      // ベーシック会員の場合
      return SvgPicture.asset("images/MotionLogoBasic.svg");
    }
  }

  Container checkIsPremiumLink(double width, double height) {
    if (_customer.isPremium) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'GO PREMIUM MEMBER',
              style: TextStyle(
                  fontSize: height * width * 0.000065,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: HexColor("FAFF00"),
                  decorationThickness: height * 0.003
              ),
            ),
            Icon(
              Icons.navigate_next,
              size: height * width * 0.0001,
            )
          ],
        ),
      );
    }
  }
}
