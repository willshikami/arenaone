# Changelog

All notable changes to the Arena One project will be documented in this file.

## [Unreleased]

### Added
- Initial project setup with Flutter 3.3x.
- Core architecture setup with directories: `lib/api`, `lib/auth`, `lib/core`, `lib/features`, `lib/navigation`, `lib/shared`.
- State management integration with `async_redux`.
- Local storage support with `sqflite` and `DatabaseHelper`.
- Modern UI implementation for Home (Your Arena) with `HomeTopBar` and `SportSelector`.
- Data models (`Team`, `Game`) using `json_serializable` and `build_runner`.
- Light theme with `Figtree` font from `google_fonts`.
- Bottom navigation with five tabs (Home, Explore, Scores, Following, Profile).

### Fixed
- "White screen" issue by flattening the widget tree and removing redundant `Scaffold` calls.
- Xcode PIF transfer session error by clearing `DerivedData` and re-installing pods.
- Code generation errors by following `build_runner` conventions.
