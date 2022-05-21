import 'package:flutter/foundation.dart';

class RegisterViewModel extends ChangeNotifier {

  bool _flag = false;
  bool get flag => _flag;

  void handleCheckbox(bool? e) {
    _flag = e!;
    notifyListeners();
  }
}
