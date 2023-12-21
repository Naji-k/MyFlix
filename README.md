# MyFlix - Your Movie Database App

MyFlix is an iOS application developed as a practice project to demonstrate various API integration techniques in Swift. It leverages The Movie Database (TMDb) API to allow users to discover, search, and manage their favorite movies and series.

## Video Demon

![Demo](https://github.com/Naji-k/MyFlix/blob/main/screenshots/movie.gif)

## Screenshots

![Main Screen](https://github.com/Naji-k/MyFlix/blob/main/screenshots/MainVC-Medium.jpeg)
![Details Screen](https://github.com/Naji-k/MyFlix/blob/main/screenshots/DetailVC-Medium.jpeg)
![Favorite Screen](https://github.com/Naji-k/MyFlix/blob/main/screenshots/FavoriteVC-Medium.jpeg)



## Key Technologies

- ***Swift 5***
- ***Handling Diverse JSON Responses (merging JSON)***: The TMDb API provides different JSON structures for TV shows and movies. Merging these varied responses has enabled the creation of generic view controllers, which can display details for both movies and TV shows.
- ***Keychain***: Securely store sensitive user data using iOS Keychain services.
- ***Nested CollectionView in TableView***: Create nesting CollectionViews within TableViews for dynamic user interfaces
- ***Generic Detail View Controller***: Developed a versatile detail view controller capable of handling and presenting data regardless of whether it's sourced from a movie or a TV show,(which is different JsonResponse) showcasing efficient use of generics in Swift.
- ***MVC (Model-View-Controller)***: This project is built using the MVC architectural pattern:
- ***Networking***: Master the art of network requests using URLSession and dataTask, handling GET, POST, and DELETE requests
- ***Error Handling***: Implement error handling to manage common networking challenges.

## Features

- ***Movie Search***: Users can search for movies/series using the TMDb API and view detailed information about each
- ***Watch List***: Add movies to your watch list to track what you want to watch later.
- ***Combination Favorites***: Combination of Favorite Movies and series in one list.
- ***Code Refactoring***: Improve code quality and maintainability through refactoring and generics.



## Getting Started

Follow these steps to get a copy of the project up and running on your local machine:

1. **Prerequisites**: 
   - Ensure you have Xcode installed on your macOS device.
   - Obtain an API key from The Movie Database (TMDb). You can generate your API key by following the instructions [here](https://developers.themoviedb.org/3/getting-started/introduction).
2. **Clone the Repository**:

    ```bash
    git clone https://github.com/Naji-k/MyFlix.git
    ```

3. **API Key Configuration**:
   - Navigate to the project directory and open the `MyFlix.xcodeproj` file.
   - Find the `TMDBClient.swift` file in the `MyFlix/Model/TMDBClient/` directory.
   - Replace the placeholder in the `apiKey` property with your TMDb API key.
4. **Build and Run**:
  - Select your target device or simulator and click the "Run" button in Xcode to build and run the app.


## Built With

- iOS 13.5
- [The Movie Database (TMDb) API](https://developers.themoviedb.org/3/getting-started/introduction)

