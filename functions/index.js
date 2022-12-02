const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require('axios');

exports.errDispatcher = functions.https.onCall(async (data, context) => {
    // Discord's maximum size of message is 2000
    if (!(typeof data === 'string') || data.length === 0 || data.length >= 2000) {
        functions.logger.info('Got inappropriate request:', data);
        return false;
    }

    const req = {'content': data};
    const isSucceeded = await axios.post(process.env.ERR_DISP_URL, req)
        .then((response) => true)
        .catch((error) => {
            functions.logger.error('Could not perform error dispatch:', error);
            functions.logger.info('The error message failed to send is:', data);
            return false;
        });

    return isSucceeded;
});

admin.initializeApp();
exports.sendCount = functions.https.onCall(async (data, context) => {
    if (context.auth === undefined || context.auth.uid === undefined) {
        functions.logger.error('context.auth.[uid] is undefined');
        return false;
    }

    try {
        const firestore = admin.firestore();
        const docRef = await firestore.collection('users').doc(context.auth.uid).get()
        var visitCount = docRef.get('visitCount');
        visitCount++;
        await firestore.collection('users').doc(context.auth.uid).update({visitCount: visitCount})
        
        parsedData = JSON.parse(data);
        const token = parsedData.token;
        const message = {
            token: token,
            data: {
                'via': context.auth.uid,
                'visitCount': visitCount.toString()
            }
        }
        res = await admin.messaging().send(message)
                .then((res) => {
                    return true;
                })
                .catch((err) => {
                    functions.logger.error(err);
                    return false;
                });
    } catch (e) {
        functions.logger.error(e);
        return false;
    }
    return res;
});
