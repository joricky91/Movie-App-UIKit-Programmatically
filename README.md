# Movie App using TMDB API (UIKit Programmatically Version)
This is a project I created to train and learn how to fetch data from API. This app features:
- List of Now Playing, Upcoming, and Top Rated movies.
- Movie details for each movie.
- Search movie based on movie's name.

This project is created for iOS platform, the tech stack I used in this projects are:
- Swift
- UIKit
- MVVM Design Pattern
- Combine
- TMDB API: https://www.themoviedb.org/documentation/api

Things I learn in this project:
- Programmatic UIKit: I learned to build user interface using programmatic UIKit, and I learn many things especially about autolayout. Before, I don't understand what is ```topAnchor```, ```bottomAnchor```, and all related autolayout syntax. But after learning through this project actually it's not that difficult to understand.
- MVVM with Combine: Before when I use SwiftUI, to bind data we just have to add ```@Published``` tag to the property in the view model that we want to observe, and then declare the instance of view model using either ```StateObject```, ```ObservedObject```, or ```EnvironmentObject```. But UIKit doesn't have that capabilities, so I need to use Combine framework to bind the view model and view controller together.

Special thanks to:
- Fitzgerald Afful's article on Medium about [Data Binding in MVVM on iOS](https://fitzafful.medium.com/data-binding-in-mvvm-on-ios-714eb15e3913).
- Swift Course video on Youtube about [How to display JSON image on UITableviewcell in Swift](https://youtu.be/KaSVqrKxb_E).

For the SwiftUI version of the Movie App, click [this link](https://github.com/joricky91/MovieApp) to view my repository.
