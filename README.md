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

To integrate VeraSDK into your Xcode project using [CocoaPods](cp), add it to your `Podfile`:

```ruby
pod 'VeraSDK', :git => 'https://github.com/resonai/vera-ios-sdk'
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

To integrate VeraSDK using [Swift Package Manager](spm), add the package dependency to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/resonai/vera-ios-sdk", branch: "main")
]
```

#### Xcode

From Xcode 11 it is possible to [add Swift Package dependencies to Xcode
projects][xcode-spm] and link targets to products of those packages; this is the
easiest way to integrate VeraSDK with an existing `xcodeproj`.

## Usage

1. Import VeraSDK into your project.

```swift
// Swift
import VeraSDK
```

2. Add the required [Info.plist keys](#infoplist-keys) if your app doesn't already.

3. Create a configuration object. Most fields are optional, check the [example integration](https://github.com/resonai/vera-ios-sdk/blob/main/Examples/VeraSDKExample-CP/VeraSDKExample-CP/TestSizeViewController.swift) for more parameters.

```swift
Vera.useConfig(
    Vera.Configuration(
        app: .init(
            clientID: "app_client_id"
        )
    )
)
```

4. Build an instance of `VeraViewController` and present it.

```swift
let vera = Vera.getController()
present(vera, animated: true)
```

## Bi-directional Communication

The SDK implements bi-directional communication between the Vera platform and the client application. Communication is done using events. Vera supports default events like `.pause`, `.resume`, `.sendDeeplink`. Check `Vera.ClientEvent` for the whole list.

### Sending Events

In order to send an event to the SDK, call the `Vera.handleEvent(_:)` method. 

#### Pause / Resume

The SDK can be paused or resumed. When paused, communication with external services like `ARSession` is stopped.

```swift
Vera.handleEvent(.pause)
```

#### Deeplinks

The SDK supports deep link-ing to some AR Experiences. In order to open a deep link, implement the `func application(_:, continue:, restorationHandler:) -> Bool` in your `UIApplicationDelegate` subclass and pass the deep link to Vera:
```swift
func application(
    _ application: UIApplication, 
    continue userActivity: NSUserActivity, 
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
) -> Bool {
    // check to make sure it's a deep link into Vera
    guard let url = userActivity.webpageURL?.absoluteString else { return false }
    Vera.sendDeeplink(url)
}
```
For an example check [this implementation](https://github.com/resonai/vera-ios-sdk/blob/e3f62fd94a051ee49ffbfec6460efee6ee15a7bc/Examples/VeraSDKExample-CP/VeraSDKExample-CP/AppDelegate.swift#L35).

#### Custom event
In order to add custom events pertaining to your own use-case, use the `sendMessage`. You can then handle this event in your own ARX app:
```swift
Vera.handleEvent(
    .sendMessage(receiver: "custom_arx_name", data: "custom_data")
)
```

### Receiving Events
In the same manner, the SDK will send you events to ask you for additional information or deliver a message from an ARX. You should be prepared to handle them:
```swift
public enum Vera.Event {
    case login
    case logout
    case refreshToken // you need to send a token into the SDK
    case handleMessage(sender: String, data: String)
}

Vera.useEventHandler { event in
   // handle event here
}
```

## Info.plist Keys

* `NSCameraUsageDescription` - VeraSDK needs access to the camera in order to support AR.
* `NSLocationWhenInUseUsageDescription` - VeraSDK needs access to location to provide accurate AR experiences.

If your app doesn't already access the camera, we recommend using something like:

* "`<your app>` needs access to the camera in order to render AR."
* "`<your app>` needs location access to provide accurate AR experiences."


[cp]: https://cocoapods.org
[spm]: https://github.com/apple/swift-package-manager
[xcode-spm]: https://help.apple.com/xcode/mac/current/#/devb83d64851
