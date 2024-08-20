# 🎥 Movies App

This Flutter application serves as a film encyclopedia, fetching data from The Movie Database (TMDB) API. Below are the key features and architectural details of the application and screenshots:

## Screenshots

<table>
  <tr>
    <td>
      <img src="/screenshots/auth_screen.png" alt="Auth screen" title="Auth screen" width="200"/>
    </td>
    <td>
      <img src="/screenshots/home_screen.png" alt="Home screen" title="Home screen" width="200"/>
    </td>
     <td>
      <img src="/screenshots/home_screen_2.png" alt="Home screen 2" title="Home screen" width="200"/>
    </td>
    <td>
      <img src="/screenshots/grid_view.png" alt="Grid view" title="Grid view" width="200"/>
    </td>
  </tr>
  <tr>
    <td>
      <img src="/screenshots/movie_details_screen_1.png" alt="Movie details 1" title="Movie details 1" width="200"/>
    </td>
    <td>
      <img src="/screenshots/movie_details_screen_2.png" alt="Movie details 2" title="Movie details 2" width="200"/>
    </td>
    <td>
      <img src="/screenshots/movie_details_screen_3.png" alt="Movie details 3" title="Movie details 3" width="200"/>
    </td>
  </tr>
  <tr>
     <td>
      <img src="/screenshots/tv_series_details_screen_1.png" alt="TV Series details 1" title="TV Series details 1" width="200"/>
    </td>
    <td>
      <img src="/screenshots/tv_series_details_screen_2.png" alt="TV Series details 2" title="TV Series details 2" width="200"/>
    </td>
    <td>
      <img src="/screenshots/tv_series_details_screen_3.png" alt="TV Series details 3" title="TV Series details 3" width="200"/>
    </td>
  </tr>
  <tr>
    <td>
      <img src="/screenshots/search_screen.png" alt="Search screen" title="Search screen" width="200"/>
    </td>
    <td>
      <img src="/screenshots/filters_sheet.png" alt="Filters sheet" title="Filters sheet" width="200"/>
    </td>
    <td>
      <img src="/screenshots/watchlist_screen.png" alt="Watchlist screen" title="Watchlist screen" width="200"/>
    </td>
    <td>
      <img src="/screenshots/account_screen.png" alt="Account screen" title="Account screen" width="200"/>
    </td>
  </tr>
</table>

## Architecture

The application architecture is divided into three layers: **data**, **domain**, and **presentation**.

- **Data Layer**: Responsible for interacting with external data sources, such as APIs or databases and making http requests. Clients in this layer handle data retrieval and storage.

- **Domain Layer**: Repositories in this layer follow patterns that define their behavior, allowing for flexible and clean logic inside the BLoC handlers.

- **Presentation Layer**: Handles the user interface and user interaction. It includes widgets, screens, and BLoC components.

## State Management

BLoC (Business Logic Component) is used for state management in the application. BLoC architecture separates business logic from UI components, making the application more modular and easier to maintain.

## Navigation

The go_router package is used for navigation within the application. It provides a flexible and declarative way to define routes and handle navigation events.

## Error Handling

The application has its own hierarchy of errors and error handlers. Error handling is implemented throughout the application, including network-related errors and other types of exceptions.

## Logging

Logging functionality is integrated into the application to provide insights into the application's behavior and aid in debugging. Navigation logging is also implemented to track navigation events.

## Data Storage

Two types of data storage are utilized in the application:

- **SharedPreferences**: Used for storing regular data.
- **FlutterSecureStorage**: Utilized for storing authentication and session-related data securely.
