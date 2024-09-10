const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnNewDocument = functions.firestore
  .document("orders/{orderId}") // Adjust this to your collection
  .onCreate(async (snap, context) => {
    const newOrder = snap.data();

    // Notification content
    const payload = {
      notification: {
        title: "New Order",
        body: `Order #${newOrder.orderId} has been placed.`,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    // Get device token(s)
    const tokens = await admin
      .firestore()
      .collection("users") // Your collection containing FCM tokens
      .doc(newOrder.userId)
      .get()
      .then((doc) => doc.data().fcmToken);

    // Send notification to the device token(s)
    if (tokens) {
      return admin.messaging().sendToDevice(tokens, payload);
    } else {
      console.log("No tokens found for this user.");
      return null;
    }
  });
