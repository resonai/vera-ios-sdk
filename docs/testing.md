# Testing

This section will guide you through the steps needed to test whether the integration was successful.

## Site Configuration

Vera can detect the site it's used in automatically, unless it is explicitly configured with specific site IDs.

> [!NOTE]  
> If you are currently located in a site supported by Vera, you can skip this step.

If your app is supposed to work with a specific site, and it has been set up, configure Vera with that site ID. Otherwise you can use our sample site.

```swift
Vera.useConfig(
    Vera.Configuration(
        app: .init(
            clientID: "<app_client_id>",
            siteIDs: ["hataasia-9-2"] // or your specific site ID
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
Otherwise you should trick Vera into thinking it is there. To do that, you can use a photo, or an image taken at that site. Below is an image you can use to test our sample site. Open the image full-screen on your monitor and point your phone to the image.

![Sample Registration](./registration.png)

As soon as you get registration, you should see 3D objects around you.

## Navigation & ARXs

When you have registration, opening Vera's side menu should show a list of AR applications available for that site. We call these applications AR Experiences, or simply **ARX**s. One of those experiences is **Navigation**. You can open it, select a POI (point of interest) on the map (i.e. Kitchen), and navigate there.

> [!NOTE]  
> On some sites, the navigation ARX can be called _Virtual Concierge_.

After you are done testing the integration, proceed to the [bi-directional communication page](./bidirectional-communication.md) to learn how to communicate with the SDK from the client app.

