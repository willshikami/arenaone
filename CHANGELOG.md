# Changelog

All notable changes to the Arena One project will be documented in this file.

## [Unreleased]

### Added
- Initial project setup with Flutter 3.3x.
- Core architecture setup with directories: `lib/data`, `lib/presentation`, `lib/redux`, `lib/utils`.
- Major project structure reorganization for better scalability (separated Data, Presentation, and Redux).
- State management integration with `async_redux` moved to `lib/redux`.
- Local storage support with `sqflite` and `DatabaseHelper` moved to `lib/data/services`.
- Modern UI implementation for Home (Your Arena) moved to `lib/presentation/home`.
- Data models (`Team`, `Game`) updated to `lib/data/models`.
- Light theme with `Figtree` font moved to `lib/utils/app_theme.dart`.
- Fixed all internal imports after file relocation.

### Fixed
- "White screen" issue by flatteing the widget tree and removing redundant `Scaffold` calls.
- Xcode PIF transfer session error by clearing `DerivedData` and re-installing pods.
- Code generation errors by following `build_runner` conventions.
