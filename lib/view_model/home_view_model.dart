import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
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

  static final List<SvgPicture> _bottomNavigationBarItems1 = [
    SvgPicture.asset('images/id_card_bottom_active.svg'),
    SvgPicture.asset('images/coffee-togo_bottom.svg'),
    SvgPicture.asset('images/settings.svg')
  ];

  static final List<SvgPicture> _bottomNavigationBarItems2 = [
    SvgPicture.asset('images/id_card_bottom.svg'),
    SvgPicture.asset('images/coffee-togo_bottom_active.svg'),
    SvgPicture.asset('images/settings.svg')
  ];

  static final List<SvgPicture> _bottomNavigationBarItems3 = [
    SvgPicture.asset('images/id_card_bottom.svg'),
    SvgPicture.asset('images/coffee-togo_bottom.svg'),
    SvgPicture.asset('images/settings_active.svg')
  ];

  int get selectIndex => _selectIndex;
  List<Widget> get pageList => _pageList;
  Widget get currentPage => _pageList[_selectIndex];
  List<SvgPicture> get bottomNavigationBarItems1 => _bottomNavigationBarItems1;
  List<SvgPicture> get bottomNavigationBarItems2 => _bottomNavigationBarItems2;
  List<SvgPicture> get bottomNavigationBarItems3 => _bottomNavigationBarItems3;

  void setStartPage() {
    _selectIndex = 0;
    notifyListeners();
  }

  void setIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  List<SvgPicture> getBottomNavigationBarItems() {
    if (_selectIndex == 0) {
      return bottomNavigationBarItems1;
    } else if (_selectIndex == 1) {
      return bottomNavigationBarItems2;
    } else {
      return bottomNavigationBarItems3;
    }
  }
}
