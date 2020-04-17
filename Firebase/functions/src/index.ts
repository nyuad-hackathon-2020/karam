import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

"use strict"

export const order_queue = functions.https.onRequest((request, response) => {
    const sender = request.get('sender')
    const seller = request.get('seller')
    const product = request.get('content')
    const timeReceived = Date()
    admin.firestore().doc('restaurants/{restaurantsID}/orders/{orderID}')
    .create()
});
 