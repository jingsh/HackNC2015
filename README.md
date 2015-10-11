# HackNC2015

## Inspiration
In many life-threatening situations, there is either no time or not practical for a person to use cellphone and ask for help.  Today we demonstrates Distress Call, an iOS app, which automatically ask help for you by hearing a preset “secret word” that you say when you in danger.  

## What it does
When you open the app, you first need to login with your facebook account. Then you can set your secret word as well as how you want to get help once you are in danger, including sending msg, calling a person or 911, uploading your location. You can use whatever word you want for the secret word, but it would be better to set word that you normally don’t use. 

## How we built it
The app leveraged a natural language processing API for voice recognition. Facebook single sign on was used to help user login, no hassle to register an account. Twilio was used as backend to send messages and make calls. A cloud app was developed to make the API calls.

## Challenges we ran into
* Accurately recognize the voice instruction.
* Integrate all backend service into one app in just a day.
* Design an intuitive, straightforward and easy to use user interface.

## Accomplishments that we're proud of
* A demo app that accomplishes all main goals

## What we learned
* Team work!
* Work hard, play harder!

## What's next for HackNC2015
We plan to work on the app. Adding more features and enhance the app performance. And publish the app to the app store eventually so it can help people out. We will also work on Android app and Windows phone app.
