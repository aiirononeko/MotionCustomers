import 'package:flutter/cupertino.dart';
import 'package:motion_customers/ui/user_screen/user_screen.dart';

import '../ui/payment_screen/payment_screen.dart';
import '../ui/point_card_screen/point_card_screen.dart';

class HomeViewModel extends ChangeNotifier {

  int _selectIndex = 0;

  static final List<Widget> _pageList = [
    const PointCardScreen(),
    const PaymentScreen(),
    const UserScreen()
  ];

  int get selectIndex => _selectIndex;

  List<Widget> get pageList => _pageList;

  Widget get currentPage => _pageList[_selectIndex];

  void setIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }
}
