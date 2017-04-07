# MemeMe

"MemeMe" :camera: is a meme-generating app developed as part of the Udacity iOS Development Nanodegree. "MemeMe" allows a user to create their own meme using a new or existing photo and share it (through email, Twitter, text or their preferred method) with friends. This is version 2.0, which adds the ability to save memes and access them through a table view controller or a collection view controller.

## Install

To check out my version of "MemeMe":

1. Clone or download my repository:
` $ https://github.com/ginnypx1/MemeMe.git `

2. Enter the "MemeMe" directory:
` $ cd /MemeMe-master/ `

3. Open "MemeMe" in XCode:
` $ open MemeMe.xcodeproj `

## Instructions

"MemeMe" initially presents the user with a table view of their saved memes, which can be seen one at a time by clicking on a table cell and transferring to a full-page view of the meme. Users can also use the tab controller to switch to a collection view of the saved memes if they prefer.

A user can add a new meme by clicking on the **+** in the top right-hand corner. They can choose to take a new photo or choose an existing photo from their Photo Album. The user can then add text to the photo in top and bottom fields, and can choose between several different meme fonts.

The user can then share :couple: and save their meme by clicking on the **Share** icon in the upper-left-hand corner, which brings up the standard Apple sharing activity view and allows the user to choose text, email, Twitter, etc.

A user can edit and re-send any saved meme by choosing the **Edit** option in the upper-left-hand corner of the table or collection view screens.

## Upgrades

I added the ability for a user to choose between several styles of font, using a slider controller on the bottom of the meme creation screen. I thought it would be particularly useful for the user to have access to "Star Wars" :boom: and "The Simpsons" :laughing: style fonts.

I used Cocoa Pods and the [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) created by @dzenbot to add a nice landing page for the user who has not yet created any memes.

In the future, I would love to add the ability to choose between several filters for the meme photo.
