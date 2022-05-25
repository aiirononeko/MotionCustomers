import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class Payment {

  /// 新規カードで決済を実施する
  Future<StripeTransactionResponse> payViaNewCard(
      String amount) async {
    initialize();
    // create payment method
    final paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    );
    // StripePayment.createSourceWithParams(options);
    final paymentIntent = await createPaymentIntent(amount);
    final confirmResult = await confirmPaymentIntent(paymentIntent, paymentMethod);
    return handlePaymentResult(confirmResult);
  }

  /// 登録済みのカードで決済を実施する
  Future<StripeTransactionResponse> payViaExistingCard(
      CreditCard creditCard, String amount) async {
    initialize();
    final paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(card: creditCard),
    );
    final paymentIntent = await createPaymentIntent(amount);
    final confirmResult = await confirmPaymentIntent(paymentIntent, paymentMethod);
    return handlePaymentResult(confirmResult);
  }

  /// Stripe初期化
  void initialize() {
    const publishableKey = 'pk_test_JQgxurljfaS5p60NmbkIiSa300jhADkIJd';
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: publishableKey,
        merchantId: 'Test',
      ),
    );
  }

  /// PaymentIntentを作成する
  Future<dynamic> createPaymentIntent(
      String amount) async {
    final paymentEndpoint = Uri.https('api.stripe.com', 'v1/payment_intents');
    const secretKey = 'sk_test_EYDJAJ0f4XC1mzW1NqomIqWk008wAaX3l8';

    final headers = <String, String>{
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, dynamic>{
      'amount': amount,
      'currency': 'jpy',
      'payment_method_types[]': 'card',
    };

    final response = await http.post(
      paymentEndpoint,
      headers: headers,
      body: body,
    );

    final paymentIntent = jsonDecode(response.body);
    return paymentIntent;
  }

  /// PaymentIntentを確定する
  Future<PaymentIntentResult> confirmPaymentIntent(
      dynamic paymentIntent, PaymentMethod paymentMethod) async {
    final confirmResult = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ),
    );
    return confirmResult;
  }

  /// PaymentIntentResultをハンドルする
  StripeTransactionResponse handlePaymentResult(
      PaymentIntentResult confirmResult) {
    if (confirmResult.status == 'succeeded') {
      return StripeTransactionResponse(
        message: 'Transaction successful',
        success: true,
      );
    } else {
      return StripeTransactionResponse(
        message: 'Transaction failed',
        success: true,
      );
    }
  }
}

/// 決済の結果
class StripeTransactionResponse {
  StripeTransactionResponse({
    required this.message,
    required this.success,
  });

  String message;
  bool success;
}
