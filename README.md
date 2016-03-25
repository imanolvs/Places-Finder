# Places-Finder

Places Finder is an app for searching some interest places like Restaurants, Lodging Sites and Leisure Sites. You can search this places using a map for selecting the location and filter them with some options. You could see their details (phone number, photos, user reviews, website, address,...) and add them to your favorites!

Steps for import, build and run the project:
- Clone the repository using the next command: "git clone https://github.com/imanolvs/Places-Finder.git"
- Open the project (Places Finder.xcodeproj file)
- For build the project: 
    - Select Product -> Build (⌘B)
- For run the project in the simulator:
    - Select the iOS device in the toolbar
    - Select Product -> Run (⌘R)
    - If there no errors, simulator will be open and you can use the app in it.

If you want load the app in a device, you have to follow next steps:
  - Go to XCode -> Preferences (⌘,)
  - Add your Apple ID Account
  - Connect your iOS Device
  - Select your iOS Device in the toolbar
  - Build and Run the project (⌘R)
  
  
How the Places Finder App works:
- Opening the Menu. You have two options to open/close the menu:
    - Sliding the screen to right (open menu) or left (close menu).
    - Tapping the top left corner button
- Menu has four entries. 
    - Favorites: This option will show your favorite places (previously, you should select the place as favorite, in the place detail view). You can swap between restaurants, hotels and leisures, tapping in the three top buttons. If you choose one place, you can see the place details.
    - Restaurants. This option allows you to search restaurants through a selected location and some filter options.
    - Hotels. This option allows you to search hotels through a selected location and some filter options.
    - Leisure Sites. This option allows you to search leisure sites through a selected location and some filter options.
- Selecting the location. You have three ways for selecting the location.
    - Perform a long gesture pressure for selecting the location you pressed in the map.
    - Tap the top right button for selecting the current user location.
    - Using the search bar. When you select a location using the search bar, a pin should be appear in the map. You will select this location tapping this pin.
- Filtering the places. There will be three filter options for restaurants and hotels, and four filter options for leisure. Optios are the following:
    - Radius: Radius in Km for fixing the places searching area.
    - Price: Set the maximum price of the place.
    - Open Now: If switch is ON, you will get the places that are open at the moment. In other case, you will get opened and closed places.
    - Leisure Venue Type (Only for Leisure Type): Set the type of the leisure venue (you have many options!!).
- Showing the places. 
    - You have two options for seeing the searched places (in a list or in the map). This differents view can be swapped using the bottom view button (Show Map, Show List).
    - For each place, you can see three place attributes: Name, Rating and a Photo (if exists).
    - Tapping the place, both the list and on the map, you could see the place details.
- Showing the place details. Show some details of the place:
    - Photo Collection. You could see the complete photo tapping in one of them. Then, sliding the photo, you could see the rest of them.
    - Name and rating.
    - Schedule.
    - Address. If you tap this row, you could see in a map the current user location and the place. This view have two bottom buttons. The right one set the map region for seeing user and place locations. The left one redirects you to Apple Maps App for get the routes available between the user location and the place location.
    - Phone Number. If you tap this row, you will perform a call to this number.
    - Website. Redirects you to the website using Safari app.
    - User Reviews. Allows you to see some user reviews about the place.
