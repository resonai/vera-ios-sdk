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

## Integration

VeraSDK provides access to the Vera platform to any Native application. When the user finds themselves in any of the Vera supported **sites** (buildings), they can open Vera and it will localize them inside the building with a very accurate precision. Once localized, the user can access any AR Experiences (**ARXs**) set up for that specific site. 

Some examples of ARXs include Navigation, 3D objects & animations, Interactions with the environment, etc.

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
            clientID: "<app_client_id>"
        )
    )
)
```

4. Build an instance of `VeraViewController` and present it.

```swift
let vera = Vera.getController()
present(vera, animated: true)
```

5. Please refer to the [testing docs](./docs/testing.md) to learn how to test if the integration was successful.

## Bi-directional Communication

Check the [bi-directional communication docs](./docs/bidirectional-communication.md) to learn how to send and receive events from the SDK.

## Info.plist Keys

* `NSCameraUsageDescription` - VeraSDK needs access to the camera in order to support AR.
* `NSLocationWhenInUseUsageDescription` - VeraSDK needs access to location to provide accurate AR experiences.

> [!NOTE]  
> Vera doesn't need location permission if you configure it with a single site ID.

If your app doesn't already access the camera, we recommend using something like:

* "`<your app>` needs access to the camera in order to render AR."
* "`<your app>` needs location access to provide accurate AR experiences."


[cp]: https://cocoapods.org
[spm]: https://github.com/apple/swift-package-manager
[xcode-spm]: https://help.apple.com/xcode/mac/current/#/devb83d64851
