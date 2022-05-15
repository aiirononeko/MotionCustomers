import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import axios, { AxiosResponse } from "axios";

const firestore = admin.firestore();

const REGION = "asia-northeast1";

const SUCCESS = 0; // 成功
const EXPIRED = 1; // 期限切れ
const DOCUMENT_NOT_FOUND = 2; // Firestoreにドキュメントなし
const NO_AUTH = 3; // 認証情報なし
const INVALID_RECEIPT = 4; // レシート情報が不正です
const ALREADY_EXIST = 5; // 同じトランザクションが存在している
const UNEXPECTED_ERROR = 99; // 不明なエラー

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
  const isConsumable: boolean = data["isComsumable"];

  const verifiedReceipt = await verifyReceiptIos(verificationData, isConsumable);

  // 最新のレシートがnullもしくはundefiendの場合はINVALID＿RECEIPT(4)を返却.
  if (verifiedReceipt === null || verifiedReceipt === undefined) {
    return { result: INVALID_RECEIPT };
  }

  // 同じtransaction_idが存在しないか確認し、購入情報が既に登録済みでないか確認する.
  const queryId: admin.firestore.DocumentData= await firestore
    .collection("Receipts")
    .doc(uid)
    .collection("Purchased")
    .doc(verifiedReceipt["transaction_id"])
    .get();

  // 購入情報が登録済みの場合はALREADY＿EXIST(5)を返却する.
  if (!queryId.empty) {
    return { result: ALREADY_EXIST };
  }

  // 最新レシートをFirestoreに保存する.
  const result: FirebaseFirestore.WriteResult = await firestore
    .collection("Receipts")
    .doc(uid)
    .collection("Purchased")
    .doc(verifiedReceipt["transaction_id"])
    .set(verifiedReceipt);

  functions.logger.info("REGIST LATEST RECEIPT RESULT: " + result);

  // レシートの有効期限が有効かどうかを確認する.
  const now: number = Date.now();
  const expireDate: number = Number(verifiedReceipt["expires_date_ms"]);
  if (now < expireDate) {
    functions.logger.info("----------------- END -----------------")
    return { result: SUCCESS };
  } else {
    functions.logger.info("----------------- END -----------------")
    return { result: EXPIRED };
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

    functions.logger.info("PRODUCTION RESPONSE: " + response);

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

      functions.logger.info("SANDBOX RESPONSE: " + response);
    }

    // レシート検証用APIから返却されたレスポンス内の`status`が`0`であれば検証は成功 https://developer.apple.com/documentation/appstorereceipts/status#possible-values
    const result = response.data;
    if (result["status"] !== 0) {
      return null;
    }

    // レスポンスデータ内の`bundle_id`が自身のパッケージ名と一致しているか確認する
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
