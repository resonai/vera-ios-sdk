<p align="center">
    <img alt="Vera: A computer vision enterprise platform that transforms buildings into intelligent environments" src="./Vera.png">
</p>
<p align="center">
A computer vision enterprise platform that transforms buildings into intelligent environments.
</p>

<p align="center">
    <a href="https://developer.apple.com/swift/"><img alt="Swift 5.7" src="https://img.shields.io/badge/swift-5.7-orange.svg?style=flat"></a>
    <a href="https://github.com/resonai/vera-ios-sdk/releases"><img alt="Vera Release" src="https://img.shields.io/github/v/release/resonai/vera-ios-sdk"></a>
</p>

## Installation

### CocoaPods

To integrate VeraSDK into your Xcode project using [CocoaPods](https://cocoapods.org), add it to your `Podfile`:

```ruby
pod 'VeraSDK', :git => 'https://github.com/resonai/vera-ios-sdk'
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

Since binary frameworks are very poorly supported by SPM, we dropped official support for it at the moment. If you are not using CocoaPods and SPM integration doesn't work out-the-box create us an issue.

## Integration

VeraSDK provides access to the Vera platform to any Native application. When the user finds themselves in any of the Vera supported **sites** (buildings), they can open Vera and it will localize them inside the building with a very accurate precision. Once localized, the user can access any AR Experiences (**ARXs**) set up for that specific site. 

Some examples of ARXs include Navigation, 3D objects & animations, Interactions with the environment, etc.

1. Import VeraSDK into your project.

```swift
// Swift
import VeraSDK
```

2. Add the required [Info.plist keys](#infoplist-keys) if your app doesn't already.

3. Create a configuration object. Most fields are optional, check the [example integration](https://github.com/resonai/vera-ios-sdk/blob/main/Example/VeraSDKDemo/ViewController.swift) for more parameters.

```swift
Vera.useConfig(
    Vera.Configuration(
        app: .init(
            clientID: "<app_client_id>"
        )
    )
)
```

4. Build an instance of `VeraViewController` and present or embed it.

```swift
//Present
let vera = Vera.getController()
present(vera, animated: true)

//Embed
vera.willMove(toParent: rootVc)
rootVc.addChild(vera)
rootVc.view.addSubview(vera.view)
vera.didMove(toParent: rootVc)
```

5. Please refer to the [testing docs](./docs/testing.md) to learn how to test if the integration was successful.

## Bi-directional Communication

Check the [bi-directional communication docs](./docs/bidirectional-communication.md) to learn how to send and receive events from the SDK.

## Closing the SDK

To close the Vera SDK and return to your application, you can just dismiss/remove Vera view controller:

Here's a sample code snippet to do so:
```swift
//Presented
vera.dismiss(animated: true)

//Embeded
vera.willMove(toParent: nil)
vera.view.removeFromSuperview()
vera.removeFromParent()
vera.didMove(toParent: nil)
```

To ensure that Vera was closed propery you can check for existing web views using Safari [Develop](https://support.apple.com/en-md/guide/safari/sfri20948/mac) menu:

You might need to [enable web inspector on device](https://developer.apple.com/documentation/safari-developer-tools/inspecting-ios)

1. Launch Safari on mac
2. Connect your device using a USB cable (can be done via wireless debug too)
3. Close the screen in your app containing Vera
4. Enter Develop menu and choose your device, look for your application's web view. If the SDK is closed properly, you should not see any entry for the Vera web view.

## Info.plist Keys

* `NSCameraUsageDescription` - VeraSDK needs access to the camera in order to support AR.
* `NSLocationWhenInUseUsageDescription` - VeraSDK needs access to location to provide accurate AR experiences.

> [!NOTE]  
> Vera doesn't need location permission if you configure it with a single site ID.

If your app doesn't already access the camera, we recommend using something like:

* "`<your app>` needs access to the camera in order to render AR."
* "`<your app>` needs location access to provide accurate AR experiences."

[spm]: https://github.com/apple/swift-package-manager
[xcode-spm]: https://help.apple.com/xcode/mac/current/#/devb83d64851
