![Header](https://raw.github.com/onionsapp/Onions-iOS/master/GithubImages/header.png)

## Onions

**Onions** is an app for iPhone (soon to be iPad) that enables users to store text-based information securely in the cloud, and uses state-of-the-art encryption schemes and an open mentalitly to forward this goal. Onions is free to use, though there is a **Pro** version available that enables users to create and store an unlimited amount of "Onions."

This app is *almost* available in the App Store, it was submitted to Apple on November 17, 2013.

The most current version is 1.0

## Table of Contents

* [What is an Onion?](#what-is-an-onion)
* [How do I build and test this app?](#how-do-i-build-and-test-this-app)
* The App
  * [Parse/API Objects](#parse-api-objects)
  * [OCSecurity](#ocsecurity)
  * [OCSession](#ocsession)
  * [Logging In / Signing Up](#logging-in--signing-up)
  * [Manipulating Onions](#manipulating-onions)
  * [3rd Party Libraries](#3rd-party-libraries)
* [Unit Tests](#unit-tests)
* [Designing for the Future](#designing-for-the-future)
* [License](#license)

## What is an Onion?

An Onion is just a blob of text-based information. It is comprised of a "Title" and "Info", representing an organizational representation of that blob. Each Title can have a max of 30 characters and each Info section can have a max of 2500 characters per Onion. This helps keep data down and promotes better organizational habits to the end user (multiple Onions for easy finding/manipulating instead of one giant one).

## How do I build and test this app?

There's only a couple things necessary to build and test the app. Here's a list you should follow, and you'll be up and running in no time.

1. Create a free [Parse.com](https://www.parse.com) account
2. Go to the [Parse Quickstart Page](https://parse.com/apps/quickstart)
4. Scroll down to Step 9, and find your Application ID and Client ID keys.
5. In Xcode, create and add a <code>ParseConstants.h</code> file that looks like this:

```objc
#ifndef OnionStorage_ParseConstants_h
#define OnionStorage_ParseConstants_h

#define PARSE_APP_ID @"YOUR_PARSE_APP_ID_KEY"
#define PARSE_CLIENT_ID @"YOUR_PARSE_CLIENT_ID_KEY"



#endif
```

Build and run the App. If everything works, we're in business!

## Parse/API Objects

Using the Parse SDK has a multitude of benefits over writing a server in Ruby or Go (or any other compilable web framework) in upholding the main goal of this app. Parse keeps us honest. The server *must* only be a storer of data; there should never be any functions that run on the server on data. We shouldn't be encrypting things after they get to the server, that introduces many more attack vectors into the equation. Knowing that Parse is a 3rd party, and that there is less friction to get in and see the data, means that we can't afford to run functions on the server. This is a good thing.

With that being said, there are only two data tables right now, Users and Onions.

**Users**

A user is only used to authenticate which data to grab from the server to then bring back to the phone, or in the opposite way of saving data associated to a user id. A user also contains a <code>Pro</code> and <code>ProReceipt</code> that categorize whether a user is Pro, and the transactionIdentifier that is successfully returned from an SKPaymentTransaction item on sale of the Pro version. I'm not doing anything with the receipt yet, but I'm keeping hold of this property just in case something happens in the future as extra assurance that a user did buy Pro and didn't flub the system somehow.

**Onion**

The Onion object contains four important properties necessary to the app.

* <code>onionTitle</code> - The title property
* <code>onionInfo</code> - The info property
* <code>iterations</code> - The iteration count used in the PBKDF2 key-stretching algorithm (10,000 currently)
* <code>userId</code> - The parameter that links the onion to a certain user (<code>[[PFUser currentUser] objectId]</code>)

We're using the iterations as a future-proof property so that as computers get faster, we can change the number of rounds for PBKDF2 dynamically. This property means that we can make the <code>kDefaultIterations</code> go up for encryption of new onions, and keep backwards compatibility to older Onions.

## OCSecurity

All of the security code is handled in the <code>OCSecurity.{h,m}</code> class. OCSecurity is basically a wrapper on top of [RNCryptor](https://github.com/rnapier/RNCryptor) which is a wrapper on top of the CommonCrypto framework included in the SDK. There are only 3 main methods that the app uses here:

**Encrypt Text**

Text encryption uses the standard RNCryptor encrypt data method that takes in a password, except I've modified it to also take in an iterations count as well. RNCryptor bakes 10,000 iterations in as the PBKDF2 iteration count, but I've changed that to future proof the app.

<code>+ (NSString *)encryptText:(NSString *)text</code> is the method that handles all encryption that Onions does.

**Decrypt Text**

Text decryption, like encryption, uses a modified RNCryptor function with an iterations parameter added. The iteration count is on the Onion object.

<code>+ (NSString *)decryptText:(NSString *)text iterations:(NSNumber *)iterations</code> is the decryption method.

**Stretching Credentials**

Before sending login/sign up information to the server I am recursively SHA-256 hashing the username and password using the following method. It does 15,000 recursive hashes and then sends it out. The only time I call this method is in the login/sign up View Controllers.

<code>+ (NSString *)stretchedCredentialString:(NSString *)credential</code>

## OCSession

<code>OCSession.{h,m}</code> is a singleton object that holds all Onion data and your plaintext password (hence the stretching of credentials) that is used to generate your AES keys and HMAC keys for encryption/decryption. The OCSession object lives at login and dies at logout. Because of the sensitive nature of the app and your data, any time the app goes to the background all of your Onion data is cleared out of memory. Nothing is ever saved on disk, and your password is **never** sent in the clear through an internet connection. Parse uses an SSL connection as it is to encrypt communications going to/from the server, but there's not point in assuming that's totally secure. All of OCSession's properties and their getters/setters/auxilliary functions have been abstracted to class-level methods that work on the <code>OCSession mainSession</code> instance.

## Logging In / Signing Up

Your user credentials are very important not to reveal to the server - or to even send through an internet connection. So, before ever authenticating your user account or creating one, I'm recursively SHA-256 hashing your username and password 15,000 times using the <code>[OCSecurity stretchedCredentialString:]</code> method. On your password, I'm actually appending your username to the end of the string before ever hashing that as well. So the process looks something like this:

```
username: "Hello"
password: "World"


becomes this:


username: "Hello"
password: "WorldHello"


which becomes this:


username:
  "VyijIO3XTijhwjrpuyDNpH
  JNpBOBKxwb180lYWbo2YY=w"

password:
  "K/SWeWOeER/zGgOYH8RXv
  BuVBzRo+0S3vK6veR/L4ko="
```

## Manipulating Onions

Onions can be created, edited and deleted. Saving an Onion will encrypt its content using the <code>[OCSession saveOnion]</code> method which runs <code>[OCSecurity encryptText]</code> on the <code>onionTitle</code> and <code>onionInfo</code> properties. It then saves the encrypted object in the background.

After you login, your previously saved Onions are retrieved from the server and then decrypted to show you on screen.

## 3rd Party Libraries

* [RNCryptor](https://github.com/rnapier/RNCryptor)
* [Colours for iOS](https://github.com/bennyguitar/Colours-for-iOS)

## Unit Tests

Right now, there is a small unit testing suite in the <code>OnionsTests</code> folder inside of the project. As of now this tests if encrypting then decrypting reveals the same string and whether the stretched credential hashing works.

## Designing for the Future

The future of this app/platform involves storing encrypted images/videos and any other file types that users could possibly want to encrypt. However, I think there are some important security milestones to hit before any of that happens:

There needs to be a way to make sure that the binary on the App Store is the binary that's here. There needs to be some assurance that the code you have on your phone is actually behaving exactly like the code behaves inside of this repository. I have no idea how to ensure this.

There need to be Unit Tests that prove extra data is not sent over an internet connection anywhere as well. I'm storing the plaintext password in the OCSession object, but there is no guarantee through Unit Tests or otherwise that it stays put and never leaves the device. I know it doesn't in the code I've written, and I can tell you that it doesn't, but there needs to be a way to prove it. I don't know how to do that right now.

## License

Onions is licensed under the **Attribution-NonCommercial 3.0 Unported** Creative Commons license.

The full text can be found [Here](http://creativecommons.org/licenses/by-nc/3.0/legalcode).
