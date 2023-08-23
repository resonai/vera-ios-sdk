# Testing

This section will guide you through the steps needed to test whether the integration was successful.

## Site Configuration

Vera can detect the site it's used in automatically, unless it is explicitly configured with specific site IDs.

> [!NOTE]  
> If you are currently located in a site supported by Vera, you can skip this step.

If your app is supposed to work with a specific site, and it has been set up, configure Vera with that site ID. Otherwise you can use our sample site - `sdk-sample-site`.

```swift
Vera.useConfig(
    Vera.Configuration(
        app: .init(
            clientID: "<app_client_id>",
            siteIDs: ["sdk-sample-site"] // or your specific site ID
        )
    )
)
```

## Registration

> [!IMPORTANT]  
> We call the process of localizing the user in 6DOF **getting registration**.

When you start Vera the first time, Vera should ask you for camera permission (and location if you didn't provide a `siteID`). After that a camera view should appear with instructions to look around.

### On-site
When you are located in the physical site, just raising the phone and looking around should result in you getting registration. 

### Off-site
Otherwise you should trick Vera into thinking it is there. To do that, you can use a photo, or an image taken at that site. Below are a couple of images you can use to test our sample site. Open any of them full-screen on your monitor and point your phone to the image.

> [!NOTE]  
> If you are off-site make sure Vera doesn't have location access. Either deny it the first time it asks, or disable it in Settings.

![Sample Registration 1](https://user-images.githubusercontent.com/100680203/262371578-78fba1a5-0f6b-4e61-9a35-e1dafd332387.png)
![Sample Registration 2](https://user-images.githubusercontent.com/100680203/262371579-babc7ab1-3381-4e24-9c8e-5b33ae2ad248.png)
![Sample Registration 3](https://user-images.githubusercontent.com/100680203/262371580-e4a76167-58d2-4a5a-bba1-4e13f2af9328.png)

As soon as you get registration, you should see 3D objects around you.

## Navigation & ARXs

When you have registration, opening Vera's side menu should show a list of AR applications available for that site. We call these applications AR Experiences, or simply **ARX**s. One of those experiences is **Navigation**. You can open it, select a POI (point of interest) on the map (i.e. Kitchen), and navigate there.

After you are done testing the integration, proceed to the [bi-directional communication page](./bidirectional-communication.md) to learn how to communicate with the SDK from the client app.

