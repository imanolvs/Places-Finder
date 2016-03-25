# Places-Finder

Places Finder is a location-aware iOS app to find interesting places such as restaurants, lodging and leisure sites. Use the map to find your favorite places and use filters to match your preferences. Get all necessary information about a place, add them to favorites and many more options.

##Import and Install
Steps to import, build and run the project:

- Clone the repository using the following command: 

```
$ git clone https://github.com/imanolvs/Places-Finder.git
```
- Open the project (`Places Finder.xcodeproj` file)
- Build the project: 
    - Select Product -> Build (⌘B)
- Run the project in the simulator:
    - Select the iOS device in the toolbar
    - Select Product -> Run (⌘R)
    - If there're no errors, simulator will open and run the app

You can also download the app into your own iOS device:
  - Go to XCode -> Preferences (⌘,)
  - Add your Apple ID Account
  - Connect your iOS Device
  - Select your iOS Device in the toolbar
  - Build and Run the project (⌘R)
  
##How the app works

- **Open the app menu**
    - Slide the screen to the right (open menu) or left (close menu), or
    - Tap the top left corner button

- **Menu entries**
    - Favorites: This option will show your favorite places (previously, you should add the place to your favorites, in the place detail view). You can select between restaurants, hotels and leisures, tapping in the three top tab-buttons. Select one place to see detail view
    - Restaurants. Select restaurants based on location and filter options
    - Hotels. Select hotels based on location and filter options
    - Leisure Sites. Select leisure sites based on location and filter options
- **Select location**
    - Long click on the map to select location
    - Tap the top right button to select current location
    - Use the search bar. A pin will appear on the map that you can click to select the location
- **Apply filters**
    - Radius: Radius in Km to define search radius around you
    - Price: Set the maximum price of the place.
    - Open Now: Select places right now open/close
    - Leisure Venue Type (Only for Leisure Type)
- **Show places**
    - Select *Show Map* or *Show List*
    - Places display *Name*, *Rating*, and *Photo*
    - Tap on a place to show more details
- **Places detail view**
    - Slide through the photo collection
    - Name and rating.
    - Schedule.
    - Address. Tap to show on the map the directions from your current location to the selected place
    - Phone Number. Tap to call
    - Website. Tap to see website in your favorite browser
    - User Reviews
