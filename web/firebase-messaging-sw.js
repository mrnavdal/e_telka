importScripts("https://www.gstatic.com/firebasejs/7.5.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.5.0/firebase-messaging.js");
firebase.initializeApp({
    apiKey: "AIzaSyDVNVQZAsXNcSsahLVAXy5KPpi038lMhs8",
    authDomain: "vecicky-162416.firebaseapp.com",
    databaseURL: "https://etelka.firebaseio.com",
    projectId: "vecicky-162416",
    storageBucket: "vecicky-162416.appspot.com",
    messagingSenderId: "222665512435",
        appId: "1:222665512435:web:efce98773a19812e0d2e86",
    measurementId: "MEASUREMENT_ID"
});
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});