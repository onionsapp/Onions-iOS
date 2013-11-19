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
  * [Logging In and Signing Up](#logging-in-and-signing-up)
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
