importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

  firebase.initializeApp({
    apiKey: 'AIzaSyDGcH4IiBIODvv-eepSUpW7h4ZV30NBUWY',
    appId: '1:899576033325:web:80ed99656a2f3ec38e08a4',
    messagingSenderId: '899576033325',
    projectId: 'web-app-test-752a1',
    authDomain: 'web-app-test-752a1.firebaseapp.com',
    storageBucket: 'web-app-test-752a1.appspot.com',
    measurementId: "G-dsada"
  });

  const messaging = firebase.messaging();

  messaging.onBackgroundMessage((message) => {
    console.log(message);
    /*
    
    const notificationTitle = message.notification.title;
    const notificationOptions = {
      body: message.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
    
    */
  });