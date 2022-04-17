import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motion_customers/service/firestore_customize.dart';

import '../entity/customers.dart';

class PointCardViewModel extends ChangeNotifier {

  Customers _customer = Customers();

  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  Customers get customer => _customer;
  String get uid => _uid;

  Future<void> init() async {
    _customer = await FirestoreCustomize.fetchCustomerInfo(_uid);
    notifyListeners();
  }

  Color checkIsPremiumColor() {
    if (_customer.isPremium) {
      // プレミアム会員の場合、イエローを返す
      return Colors.yellowAccent;
    } else {
      // ベーシック会員の場合、ブラックを返す
      return Colors.black;
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
      return Container(
        decoration: const BoxDecoration(
          color: Colors.yellowAccent,
        ),
        child: SvgPicture.asset('images/id_card.svg'),
      );
    } else {
      // ベーシック会員の場合
      return SvgPicture.asset('images/id_card.svg');
    }
  }
}
