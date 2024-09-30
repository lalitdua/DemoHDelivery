# DemoHDelivery


This is an iOS application built using Swift. The app integrates Google Maps for location-based features. Follow the steps below to set up and run the project on your machine.

## Table of Contents

1. [Requirements](#requirements)
2. [Project Setup](#project-setup)
3. [Google API Key Setup](#google-api-key-setup)
4. [Running the Project](#running-the-project)
5. [Support](#support)

## Requirements

Before you begin, ensure you have the following:

- macOS with Xcode installed (version 12 or later).
- CocoaPods (for dependency management).
- A Google Cloud account with access to the Google Maps SDK for iOS.

## Project Setup

### 1. Clone the repository:

```bash
git clone https://github.com/lalitdua/DemoHDelivery
cd DemoHDelivery

2. Install dependencies:
This project uses CocoaPods to manage dependencies. Make sure CocoaPods is installed, then run the following command in the project directory:

pod install

This will install all the required dependencies, including the Google Maps SDK.

3. Open the project in Xcode:
Use the .xcworkspace file to open the project:

open DemoHDelivery.xcworkspace


Google API Key Setup
To use Google Maps in your project, you need to obtain a Google API key and configure it in the app.

Steps to get your Google API key:
Go to the Google Cloud Console.
Create or select an existing project.
Go to the APIs & Services dashboard and enable the Google Maps SDK for iOS.
Generate an API key in the Credentials section.
Add the API Key to the App
Once you have the API key, follow these steps to add it to your project:

Open AppDelegate.swift.
Locate the application(_:didFinishLaunchingWithOptions:) method.
Add the following line with your API key:

Replace "YOUR_GOOGLE_API_KEY" with your actual API key.

Running the Project
Once you’ve set up your API key and dependencies, you can run the project:

Select your target device or simulator in Xcode.
Press Cmd + R to build and run the project.
Support
If you encounter any issues, feel free to open an issue on the GitHub repository or contact the project maintainer.
