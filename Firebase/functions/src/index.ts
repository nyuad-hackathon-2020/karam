import * as functions from 'firebase-functions';
export const helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// 
