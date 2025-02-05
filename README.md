# RickAndMortyCleanSwift

## Overview
RickAndMortyCleanSwift is an iOS app that displays a list of characters from the *Rick and Morty* series. It is built using **Clean Swift architecture** and supports offline access with **CoreData**, caching images with **FileManager**.

---

## Technologies
- **Language:** Swift 5
- **Architecture:** Clean Swift
- **Core Frameworks:** UIKit, CoreData, FileManager
- **API:** [Rick and Morty API](https://rickandmortyapi.com/documentation/)

---

## Setup and Run

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd RickAndMortyCleanSwift

2. **Open the project in Xcode:**
   - Open `RickAndMortyCleanSwift.xcodeproj`.
   - Ensure Swift 5 and iOS 15+ are configured.

3. **Run the app:**
   - Select a simulator or physical device.
   - Press `Cmd + R` to build and run the application.

---

## Features
- **Clean Swift Modules**: Each feature adheres to Clean Swift principles, with a clear separation of responsibilities into ViewController, Interactor, Presenter, Router, and Models.
- **Offline Access**: Data is stored locally using CoreData for seamless offline functionality.
- **Image Caching**: Images are cached locally using FileManager for efficient loading and performance.
- **Network Monitoring**: Adapts to network changes and provides a fallback to cached data when offline.

---

## Architecture

### Clean Swift
This project adheres to the Clean Swift architecture pattern:
- **ViewController**: Responsible for the UI layer and receiving user interactions.
- **Interactor**: Contains the business logic and communicates with services or managers.
- **Presenter**: Formats data for display and prepares it for the ViewController.
- **Router**: Handles navigation logic and screen transitions.
- **Models**: Defines request, response, and view models for structured data flow.

---

## Low-Level Services
- **NetworkService**: Handles API calls, error responses, and pagination logic.
- **ImageLoader**: Fetches images asynchronously, caching them for optimized performance.
- **ImageCacheManager**: Manages image caching in the file system, ensuring availability offline.
- **CoreDataManager**: Provides local data persistence using Core Data, enabling offline access to characters.

---

## Questions and Suggestions

For any questions or suggestions, please feel free to open an issue on GitHub.

This README is clear, concise, and follows best practices. It will help developers understand the project and set it up easily.
