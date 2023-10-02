#  UOKiosk Documentation

# Table of Contents
1. [Description](#description)
2. [Usage](#usage)
3. [Arhitecture](#arhitecture)
4. [Dependencies](#dependencies)
5. [Feedback](#Feedback)
6. [Design](#design)
7. [API](#api)

# UO Kiosk
An app for University of Oregon students to stay informed and engaged

# Description
<p>A must have app for any University of Oregon student, visitor, or faculty.
UO Kiosk is here to keep you informed on up-to-date events going on on campus, in school news, and on the radio.
Find what stores are open and links to useful websites like Canvas and the Student Housing Portal.</p>

# Usage
Download Beta on [Test Flight](https://testflight.apple.com/join/fjzSKNgi)

# Architecture
* UO Kiosk project is implemented using the <strong>Model-View-ViewModel (MVVP)</strong> architecture pattern.
* Other deatils coming soon

# Dependencies
Using swift package manager for integrating dependencies
List of dependencies:
* TBD

# Feedback

* Reporting bugs:<br>
If you come across any issues while using the UO Kisok, please report them by filling out the feedback form through the app or emailing uokiosk@gmail.com .

* Reporting bugs form: <br>
```
App version: 1.23
iOS version: 17.0
Description: When I open a different tab after starting the radio the app crashes.
Steps to reproduce: Open "radio" tab in the app, press play, open events tab.
```

* Providing feedback:<br>
If you have any feedback or suggestions for the UO Kiosk project, please contact the maintainer through the feedback button in the app or by sending an email to the project maintainer at uokiosk@gmail.com .

# Design
* Design is based on Charles Robinson's app for [Seattle University](https://apps.apple.com/ng/app/su-campus/id1600356652)
* Charles Robinson knows of the development of UO Kiosk and has given permission to his UI/UX design
* Implimentation is not at all based on Charles Robinson's code. The developer of UO Kisok have not viewed any of Charles Robinson's code to program UO Kiosk

# API
* The app uses a couple REST APIs and an RSS feed
* For the on-campus event feed we are using [Localist](https://www.localist.com)
* For the What's Open tab the app uses an API through [Woosmap](https://www.woosmap.com/en)
* The [UO Map](https://map.uoregon.edu) is at the attatched link.
* For the news feed we are using an rss feed from [The Daily Emerald](https://www.dailyemerald.com)
* For the radio we are using a link to stream using AVFoundation from [KWVA](https://kwva.uoregon.edu)

