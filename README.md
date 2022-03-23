# Vera iOS SDK
Official repo for Vera iOS SDK.

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

2. Create a configuration object.

```swift
let config = VeraConfiguration(
    app: .init(clientID: "vera_client_app"),
    user: .init(username: nil),
    eventHandler: { event in
        switch event {
        case .refreshToken:
            print("refresh the token")
        @unknown default:
            fatalError()
        }
    }
)
```

3. Build an instance of `VeraViewController` using the configuration and present it.

```swift
let vera = VeraViewController.build(config: config)
present(vera, animated: true)
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
