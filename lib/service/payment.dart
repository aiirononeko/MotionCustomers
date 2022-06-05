import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:motion_customers/service/firestore_service.dart';

class Payment {

  /// customers/{uid}/checkout_sessionsのDocを作成
  Future<DocumentReference> createCheckoutSessions(BuildContext context, String uid, String priceId) async {

    if (priceId == 'price_1L3IukFnaADmyp9oeuguCRH3') {
      return await FirestoreService().createCheckoutSessionsForSubscription(context, uid, priceId);
    } else {
      return await FirestoreService().createCheckoutSessionsForCoffeeTicket(context, uid, priceId);
    }
  }
}
