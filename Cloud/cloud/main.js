// Include Cloud Code module dependencies
var express = require('express'),
twilio = require('twilio');

// Create an Express web app (more info: http://expressjs.com/)
var app = express();

// Create a route that will respond to am HTTP GET request with some
// simple TwiML instructions
app.get('/callcenter', function(request, response) {
    // Create a TwiML response generator object
    var twiml = new twilio.TwimlResponse();

    // add some instructions
    twiml.say('Hello! This is a test app!', {
        voice:'woman'
    });

    // Render the TwiML XML document
    response.type('text/xml');
    response.send(twiml.toString());
});

// Start the Express app
app.listen();

// Include the Twilio Cloud Module and initialize it
//var twilio = require("twilio");
var accountSid = 'ACe92fd1fcb9e07d9d138b6e27fee28068';
var authToken = 'bd4b9761b41e689bb10b79d1bd5d06dc';

var client = require('twilio')(
    accountSid, // Account SID
    authToken // auth token
);

// Create the Cloud Function for sendSMS
Parse.Cloud.define("sendSMS", function(request, response) {
    // Use the Twilio Cloud Module to send an SMS
    client.sendSms({
        to: request.params.to, //"+19196999542", //request.params.to,
        from: "+19192960769",
        body: request.params.message //"Hello! This is a test message!"
    }, function(error, data) {
        // Handle the result of placing the outbound call
        if (error) {
            response.error('there was a problem :(');
        } else {
            console.log(data.to);
            console.log(data.body);
            response.success('SMS sent!');
        }
    });
});

// Create the Cloud Function for makeCall
Parse.Cloud.define('makeCall', function(request, response) {
    // Place an outbound call
    client.makeCall({
        to: request.params.to, //'+19196999542',//'', // the number you wish to call
        from: '+19192960769', // a valid Twilio number you own
        url: 'https://HackNC.parseapp.com/callcenter', // TwiML URL
        method: 'GET' // HTTP method with which to fetch the TwiML
    }, function(error, data) {
        // Handle the result of placing the outbound call
        if (error) {
            response.error('there was a problem :(');
        } else {
            console.log(data.to);
            response.success('call incoming!');
        }
    });
});
