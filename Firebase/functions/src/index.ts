import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

"use strict"

export const order_queue = functions.https.onRequest((request, response) => {
   
    const sender = request.get('sender')!
    const seller = request.get('seller')!
    const product = request.get('content')!
    const timeReceived = Date()
    const db = admin.firestore()
    db.collection('restaurants').doc(seller).collection('orders')
    .add({
        'by' : sender,
        'at' : timeReceived,
        'content': product
    }).then(function(docRef){
        console.log("Document order created with ID:",docRef.id)
        response.send('Success')
    })
    .catch(function(error){
        console.error("Failed to add document order",error);
        response.send(JSON.stringify(error))
    });
})
 