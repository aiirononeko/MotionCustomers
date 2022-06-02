import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

import axios, { AxiosResponse } from "axios";
import Stripe from 'stripe';

const firestore = admin.firestore();
const REGION = "asia-northeast1";

export const helloWorld = functions.region(REGION).https.onRequest( async (request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const stripeEventWebhook = functions.region(REGION).https.onRequest(async (req, res) => {
  const event = req.body;
  const checkoutSession = event.data.object as Stripe.Checkout.Session;
  const customerId = checkoutSession.customer as string;

  // Get customer's UID from Firestore
  const customersSnap = await admin.firestore()
    .collection('customers')
    .where('stripeId', '==', customerId)
    .get();
  if (customersSnap.size !== 1) {
    res.send('User not found.');
  }
  const uid = customersSnap.docs[0].id;

  switch (event.type) {
    case  'checkout.session.completed': {
      // Customerの会員情報をプレミアム会員にする
      firestore.collection("Customers").doc(uid).update({
        "isPremium": true
      });
      res.send('User status changed (basic -> premium).');
    }
    case 'invoice.payment_failed': {
      // Customerの会員情報をベーシック会員にする
      firestore.collection("Customers").doc(uid).update({
        "isPremium": false
      });
      res.send('User status changed (premium -> basic).');
    }
    default: {
      res.send('Some error occured.');
    }
  }
  res.send('Do nothing.');
}); 

const SUCCESS = 0; // 成功
const EXPIRED = 1; // 期限切れ
const DOCUMENT_NOT_FOUND = 2; // Firestoreにドキュメントなし
const NO_AUTH = 3; // 認証情報なし
const INVALID_RECEIPT = 4; // レシート情報が不正です
const ALREADY_EXIST = 5; // 同じトランザクションが存在している
// const UNEXPECTED_ERROR = 99; // 不明なエラー

const PACKAGE_NAME_IOS = "motion.motionCustomers";

const RECEIPT_VERIFICATION_ENDPOINT_FOR_IOS_SANDBOX = "https://sandbox.itunes.apple.com/verifyReceipt";
const RECEIPT_VERIFICATION_ENDPOINT_FOR_IOS_PROD = "https://buy.itunes.apple.com/verifyReceipt";

export const verifyReceipt = functions.region(REGION).https.onCall(async (data, context) => {
  functions.logger.info("----------------- START -----------------")

  // 認証情報がない場合はNO_AUTH(3)を返却.
  if (context.auth === null) {
    return { result: NO_AUTH };
  }

  const uid: string = context.auth!.uid;
  const verificationData: string = data["data"];
  const isConsumable: boolean = data["isConsumable"];

  const verifiedReceipt = await verifyReceiptIos(verificationData, isConsumable);

  // 最新のレシートがnullもしくはundefiendの場合はINVALID＿RECEIPT(4)を返却.
  if (verifiedReceipt === null || verifiedReceipt === undefined) {
    return { result: INVALID_RECEIPT };
  }

  // 同じtransaction_idが存在しないか確認し、購入情報が既に登録済みでないか確認する.
  const query = firestore
    .collection("Receipts")
    .doc(uid)
    .collection("Purchased")
    .doc(verifiedReceipt["transaction_id"])
    .get();

  // 購入情報が登録済みの場合はALREADY＿EXIST(5)を返却する.
  if ((await query).exists) {
    return { result: ALREADY_EXIST };
  }

  // 最新レシートをFirestoreに保存する.
  const result: FirebaseFirestore.WriteResult = await firestore
    .collection("Receipts")
    .doc(uid)
    .collection("Purchased")
    .doc(verifiedReceipt["transaction_id"])
    .set(verifiedReceipt);

  functions.logger.info("REGIST LATEST RECEIPT RESULT: " + result.toString());

  if (isConsumable) {
    // コーヒーチケットの場合、成功のレスポンスを返却する.
    functions.logger.info("----------------- END -----------------")
    return { result: SUCCESS };
  } else {
    // サブスクアイテムの場合、レシートの有効期限が有効かどうかを確認する.
    const now: number = Date.now();
    const expireDate: number = Number(verifiedReceipt["expires_date_ms"]);
    if (now < expireDate) {

      // 有効期限内の場合、定期更新のためレシートとレシートの有効期限をCustomersコレクションに登録する.
      await firestore.collection("Customers").doc(uid).update({
        "subscription_receipt": verificationData,
        "expires_date_ms": verifiedReceipt["expires_date_ms"]
      });

      functions.logger.info("----------------- END -----------------")
      return { result: SUCCESS };
    } else {
      return { result: EXPIRED };
    }
  }
})

// レシートデータを検証してlatest_receiptを返す
export async function verifyReceiptIos(verificationData: string, isConsumable: boolean) {

  let response: AxiosResponse;

  try {

    // 本番用APIにデータを送信する
    response = await axios.post(RECEIPT_VERIFICATION_ENDPOINT_FOR_IOS_PROD, {
      "receipt-data": verificationData,
      password: process.env.RECEIPT_VERIFICATION_PASSWORD_FOR_IOS,
      "exclude-old-transactions": true,
    });

    // 本番用APIから返却された`status`が`21007`の場合、送信されたレシートがサンドボックス環境用と判断する
    if (response.data && response.data["status"] === 21007) {
      response = await axios.post(
        RECEIPT_VERIFICATION_ENDPOINT_FOR_IOS_SANDBOX,
        {
          "receipt-data": verificationData,
          password: process.env.RECEIPT_VERIFICATION_PASSWORD_FOR_IOS,
          "exclude-old-transactions": true,
        }
      );
    }

    // レシート検証用APIから返却されたレスポンス内の`status`が`0`であれば検証は成功 https://developer.apple.com/documentation/appstorereceipts/status#possible-values
    const result = response.data;

    functions.logger.info("STATUS CODE: " + result["status"]);

    if (result["status"] !== 0) {
      return null;
    }

    // レスポンスデータ内の`bundle_id`が自身のパッケージ名と一致しているか確認する
    functions.logger.info("BUNDLE ID: " + result["receipt"]["bundle_id"]);

    if (
      !result["receipt"] ||
      result["receipt"]["bundle_id"] !== PACKAGE_NAME_IOS
    ) {
      return null;
    }

    if(isConsumable) {
      return result["receipt"]["in_app"][0]; // TODO 購入失敗したものがまとめて返却される可能性があるため、トランザクション処理を検討する.
    } else {
      // `latest_receipt_info`は定期購読タイプのアイテムを購入したことがある場合のみ存在する
      return result["latest_receipt_info"][0];
    }
  } catch (err) {
    return null;
  }
}

// サブスクリプションが有効かどうかを確認する.
export const verifyUserStatus = functions.region(REGION).https.onCall(async (_, context) => {

  functions.logger.info("----------------- START -----------------")

  const uid: string = context.auth!.uid;
  const user = (await firestore.collection("Customers").doc(uid).get()).data(); // User情報取得

  if (user !== undefined) {
    // レシートの有効期限が有効かどうかを確認する.
    const now: number = Date.now();
    const expireDate: number = Number(user["expires_date_ms"]);
    if (now > expireDate) {
      // 有効期限が切れている場合、AppStoreにユーザー情報を問い合わせる.
      const verifiedReceipt = await verifyReceiptIos(user["subscription_receipt"], false);
      const expireDate: number = Number(verifiedReceipt["expires_date_ms"]);
      if (now > expireDate) {
        // 有効期限が切れている場合、ユーザーステータスを変更する.
        firestore.collection("Customers").doc(uid).update({
          "isPremium": false
        });
        return { result: EXPIRED };
      }
    }

    functions.logger.info("----------------- END -----------------")
    return { result: SUCCESS };
  } else {
    return { result: DOCUMENT_NOT_FOUND };
  } 
});

export const deleteCustomer = functions.region(REGION).firestore.document("WithdrawCustomers/{docId}").onCreate(async (snap, context) => {
  
  const deleteDocument = snap.data();
  const uid = deleteDocument.uid;

  // Authenticationのユーザーを削除する.
  await admin.auth().deleteUser(uid);

  // Firestoreのカスタマーを削除する.
  // よくわからんけど復旧したい時とか使えるかもだから残しておく
  // await firestore.collection("Customers").doc(uid).delete();
});

export const activationCustomer = functions.region(REGION).firestore.document("customers/{userId}/subscriptions/{docId}").onCreate(async (snap, context) => {

  const subscriptionData = snap.data();
  const uid = context.params.userId;

  if (subscriptionData['status'] == 'active') {
    await firestore.collection('Customers').doc(uid).update({
      "isPremium": true
    })
  }
});

export const disActivationCustomer = functions.region(REGION).firestore.document("customers/{userId}/subscriptions/{docId}").onUpdate(async (snap, context) => {

  const subscriptionData = snap.after.data();
  const uid = context.params.userId;
  if (subscriptionData['status'] != 'active') {
    await firestore.collection('Customers').doc(uid).update({
      "isPremium": false
    })
  }
});

export const addCoffeeTicket = functions.region(REGION).firestore.document("customers/{userId}/payments/{docId}").onCreate(async (snap, context) => {

  const data = snap.data();
  const uid = context.params.userId;

  if (data['amount'] == '5000') {
    if (data['status'] == 'succeeded') {
      const customerData = (await firestore.collection('Customers').doc(uid).get()).data();
      if (customerData != undefined) {
        await firestore.collection('Customers').doc(uid).update({
          "coffeeTickets": customerData['coffeeTickets'] + 11
        });
      }
    }
  }
});
