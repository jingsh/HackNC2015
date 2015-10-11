# HackNC2015

##Introducing [Distress Call](https://jingsh.github.io/HackNC2015/)

## Inspiration
In many life-threatening situations, there is either no time or not practical for a person to use his/her cellphone and ask for help. This is why we created Distress Call, a smart iOS app that can understand your voice instructions and alerts your friends and family when it hears a preset “secret word” from you. 

## What it does
When Distress Call is opened, it will continuously analyze your voice. Distress Call will not do anything unless it hears your “secret word”. Once it detects that your need help, Distress Call will quickly respond and help you, including:

* Send a help message to your contacts with your GPS location
* Make a call to your contacts with pre-recorded message or call 911
* Uploading your changing GPS location onto the server where your contacts can help where you are
* Make a fake call to yourself when you are in uncomfortable dating or situation similar
* Make audible alarm
* Use the flash on your cellphone

## How we built it
The app leverages a natural language processing API for voice recognition. Facebook single sign on is used to help user login, no hassle to register a new account. Twilio is used as backend to send messages and make calls. A cloud app is developed to make the API calls.

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
We plan to continuously work on the app, including adding more features into the app and improving the app performance. We plan to publish the app to the app store so it can help people out. We will also work on Android app and Windows phone app in the future.
