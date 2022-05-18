import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../entity/customers.dart';
import '../service/firestore_customize.dart';

class UserViewModel extends ChangeNotifier {

  Customers _customer = Customers();

  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  Customers get customer => _customer;

  String get uid => _uid;

  Future<void> init() async {
    _customer = await FirestoreCustomize.fetchCustomerInfo(_uid);
    notifyListeners();
  }
}
