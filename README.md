# Arena One

Arena One is a cross-sport tracking and personalization app designed to give users a single, unified arena for all the sports they care about. It helps users follow teams, leagues, players, and tournaments, see upcoming games, track live scores, view standings, and receive timely notifications.

## 🚀 Features

- **Your Arena (Home)**: Unified view of upcoming games, live scores, and highlights.
- **Explore**: Discover new sports, trending topics, and major tournaments.
- **Scores**: Detailed view of live, recent, and upcoming scores filtered by sport or league.
- **Following**: Centralized space for your tracked teams, athletes, and tournaments.
- **Profile**: Manage your settings, notifications, account, and app theme.

## 🛠️ Tech Stack

- **Flutter**: Cross-platform development.
- **Async Redux**: Robust state management.
- **SQFlite**: Local data persistence.
- **JSON Serializable**: Efficient data modeling.
- **Google Fonts (Figtree)**: Clean and modern typography.

## 📁 Project Structure

```text
lib/
├── api/          # API clients & models (Generated with Retrofit/GraphQL)
├── auth/         # Authentication flow and state
├── core/         # Core configurations, theme, and services
├── features/     # Feature modules (home, profile, etc.)
├── navigation/   # Centralized routing and navigation logic
├── shared/       # Reusable UI widgets
└── main.dart     # Entry point
```

## 🏗️ Getting Started

1.  **Clone the repository**.
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Generate code**:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  **Run the app**:
    ```bash
    flutter run
    ```

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for details on recent updates.
