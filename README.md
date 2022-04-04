# Project: Weather with NAB

Below are some specifications of this project:

## Architecture:
The projects uses MVVM architecture with a view model for the only view, `EntryViewController`, which is a list view of weather data. Besides, some auxiliary models were made for assistant procedures:
- API fetching 
- Object mapping from server’s JSON to designated classes.
- UI helpers with customised elements and constants to use in the app.
- etc.

## Structure
The project’s tree folder is already arranged as Models, Views, ViewModels and Services as the developer can find it easy to change and continuously develop the app. Inside the Views folder, some sub-UI classes are also stored.

The libraries as below are used in the project to help making things done in a comfortable way:
- `SwiftyJSON`: helps to get data in primitive Swift types from JSONs
- `ObjectMapper`: helps to map/query data from JSON string to classes easily.
- `AlamoFire`: replaces URLSession in getting data from server.

## Steps to run the project
1. Make sure Xcode 12 or above is installed.
2. Inside the project folder, run `pod install` on Intel Mac, in case of Silicon Mac, please run this command with x86_64 option.
3. Open the `.xcworkspace` file.
4. Run the project with pressing Play button on the main toolbar.

## Check list based on outputs expected
- [x] Programming language: Swift is required, Objective-C is optional. 
- [x] Design app's architecture (recommend VIPER or MVP, MVVM but not mandatory) 
- [x] UI should be looks like in attachment. 
- [x] Write UnitTests
- [x] Exception handling 
- [ ] Accessibility for Disability Supports
- [ ] Entity relationship diagram for the database and solution diagrams for the components, infrastructure design if any.
- [x] Readme file 

