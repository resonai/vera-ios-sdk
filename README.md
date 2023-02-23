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

2. Create a configuration object. Most fields are optional, check the [example integration](https://github.com/resonai/vera-ios-sdk/blob/main/Examples/VeraSDKExample-CP/VeraSDKExample-CP/TestSizeViewController.swift) for more parameters.

```swift
Vera.useConfig(
    .init(
        app: .init(
            clientID: "vera_client_id"
        )
    )
)
```

3. Build an instance of `VeraViewController` and present it.

```swift
let vera = Vera.getController()
present(vera, animated: true)
```

## Bi-directional Communication

The SDK implements bi-directional communication between the Vera platform and the client application. Communication is done using events.

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
The client app can send events to any of our public your custom AR Experiences:
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

### Firebase Auth
Vera SDK prefers Firebase tokens for authentication. If you have Firebase Auth set up in your app, next step is to communicate it to Vera. Check the example app to see an implementation.

The SDK will ask for the token several times using the `.refreshToken` event.

1. Make sure you have Firebase set up and we support your project:
* You should have an iOS project set up in the Firebase Console.
* The Vera backend should support your Firebase service account.
* Your project should be set up in Google Cloud console.
* You should have Firebase Authentication enabled in the console.

2. Send the Firebase client id when setting up Vera configuration:
```swift
Vera.useConfig(
    .init(
        ...,
        app: .init(
            clientID: FirebaseApp.app()?.options.clientID ?? "<custom_client_id>",
            ...
        ),
        ...
    )
)
```


3. Handle `.login`, `.logout` and `.refreshToken` events from the SDK:
```swift
Vera.useEventHandler { [weak self] event in
    switch event {
    case .login:
        self?.login()
    case .logout:
        self?.logout()
    case .refreshToken:
        self?.renewAuthToken(forcingRefresh: true)
    case let .handleMessage(sender: sender, data: data):
        print("Sender: \(sender) -> \(data)")
    @unknown default:
        fatalError()
    }
}
```

4. Implement the methods:
```swift
private func renewAuthToken(forcingRefresh: Bool) {
    Auth.auth().currentUser?.getIDTokenForcingRefresh(forcingRefresh) { idToken, error in
        if let error = error {
            print(error.localizedDescription)
            if AuthErrorCode(_nsError: error as NSError).code == .networkError {

                // we let the SDK know we're offline when a network error occurs
                Vera.handleEvent(.updateToken(.offline))
            }
            return
        }
        let currentUserId = Auth.auth().currentUser?.uid ?? ""

        // There either is a token or there isn't, in any case we let the SDK know
        Vera.handleEvent(.updateToken(idToken.map { .loggedIn(token: $0, userID: currentUserId) } ?? .anonymous))
    }
}

private func login() {
    // Show default Firebase auth controller on top of the Vera screen
    guard let viewController, let authUI = FUIAuth.defaultAuthUI() else { return }
    authUI.delegate = self
    viewController.present(authUI.veraAuthController(), animated: true, completion: nil)
}

private func logout() {
    do {
        try FUIAuth.defaultAuthUI()?.signOut()
    } catch {
        print("ERROR: \(error)")
    }
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
