# Bi-directional Communication

The SDK implements bi-directional communication between the Vera platform and the client application. 

Communication is done using events. Vera supports default events like `.pause`, `.resume`, `.sendDeeplink`. 

## Events

In order to send an event to the SDK, call the `Vera.handleEvent(_:)` method. Check `Vera.ClientEvent` for the whole list.

### Pause / Resume

The SDK can be paused or resumed. When paused, communication with external services like `ARSession` is stopped.

```swift
Vera.handleEvent(.pause)
```

### Deeplinks

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

### Receiving Events
> [!WARNING]
> Only handle incoming events if you have a specific use-case or have been instructed to do so.

In the same manner, the SDK will send you events to ask you for additional information or deliver a message from an ARX. You should be prepared to handle them. Check the `Vera.Event` enum for all cases.
```swift
Vera.useEventHandler { event in
    switch event {
    case .login:
        ...
    case .logout:
        ...
    }
}
```

## Communicating to ARXs

Since Vera is the platform where multiple Native apps can use different ARXs on the same site, we implemented a generic way to communicate between these apps through the SDK.

### Sending Messages
In order to send custom events to ARXs use the `sendMessage` event. You can then handle this event in your own ARX app:
```swift
Vera.handleEvent(
    .sendMessage(receiver: "custom_arx_name", data: "custom_data")
)
```

> [!NOTE]
> The `Vera.sendDeeplink` method is mostly a shortcut for communicating with the Navigation ARX. Check [example code](https://github.com/resonai/vera-ios-sdk/blob/6dbfe36e7eea6cecdf850160aa17b4f154459f5f/Examples/VeraSDKExample-CP/VeraSDKExample-CP/ViewController.swift#L105).

### Receiving Messages
The same way you send events to ARXs, you can receive events from ARXs.

```swift
Vera.useEventHandler { event in
    switch event {
    case let .handleMessage(sender, data):
        print("ARX \(sender): \(data)")
    }
}
```