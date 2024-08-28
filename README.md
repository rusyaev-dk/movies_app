# 🎥 Movies App

This Flutter application serves as a film encyclopedia, fetching data from The Movie Database (TMDB) API. Below are the key features and architectural details of the application and screenshots:

## Screenshots
![Main menu](/screenshots/movies_app_screenshot_1.jpg "Main menu")

![Movie details](/screenshots/movies_app_screenshot_2.jpg "Movie details")

![Search and watchlist screen](/screenshots/movies_app_screenshot_3.jpg "Search and watchlist screen")

![Account and person info](/screenshots/movies_app_screenshot_4.jpg "Account and person info")

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

- `shared_preferences`: for storing regular data;
- `flutter_secure_storage`: for storing authentication and session-related data securely.
