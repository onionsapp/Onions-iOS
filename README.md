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
  * [View Controllers](#view-controllers)
  * [3rd Party Libraries](#3rd-party-libraries)
* [Designing for the Future](#designing-for-the-future)
* [License](#license)

## What is an Onion?

An Onion is just a blob of text-based information. It is comprised of a "Title" and "Info", representing an organizational representation of that blob. Each Title can have a max of 30 characters and each Info section can have a max of 2500 characters per Onion. This helps keep data down and promotes better organizational habits to the end user (multiple Onions for easy finding/manipulating instead of one giant one).

## How do I build and test this app?

There's only a couple things necessary to build and test the app. Here's a list you should follow, and you'll be up and running in no time.

1. Create a free [Parse.com](https://www.parse.com) account
2. Go to the [Parse Quickstart Page](https://parse.com/apps/quickstart) and download the Parse SDK for iOS
3. Add the Parse framework by following the instructions on the page.
4. Stop at Step 9, and find your Application ID and Client ID keys.
5. In Xcode, create and add a <code>ParseConstants.h</code> file that looks like this:

```objc
#ifndef OnionStorage_ParseConstants_h
#define OnionStorage_ParseConstants_h

#define PARSE_APP_ID @"YOUR_PARSE_APP_ID_KEY"
#define PARSE_CLIENT_ID @"YOUR_PARSE_CLIENT_ID_KEY"



#endif
```

Build and run the App. If everything works, we're in business! If not, go through the Parse installation process and make sure you followed all of the directions for adding the Framework, and that all of the extra frameworks are installed as well.


