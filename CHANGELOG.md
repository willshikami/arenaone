# Changelog

All notable changes to the Arena One project will be documented in this file.

## [1.0.0-alpha.7] - 2026-02-22 16:05

### Changed
- Reimagined the **Event Card** design with a focus on depth and premium sports aesthetics.
- Added a `Material` `InkWell` surface to match cards for better interactive feedback.
- Enhanced card layout with larger team containers (`64x64`) and subtle background glows.
- Improved match information hierarchy:
  - Added a brand-color vertical accent for league identification.
  - Redesigned the "VS" indicator with a stylized background badge.
  - Increased score typography to `32pt` with heavy weights for better impact.
- Refined footer information (Stadium, Channel) with custom icons and consistent spacing.

## [1.0.0-alpha.6] - 2026-02-22 15:45

## [1.0.0-alpha.5] - 2026-02-22 15:30

## [1.0.0-alpha.4] - 2026-02-22 15:15

### Added
- Transitioned the entire application to a high-performance **Dark Theme**.
- Implemented a "Unified Dark" design language with background `#0D0D10` and surface `#16161C`.
- Integrated a subtle orange gradient header (inspired by Apple Sports) at the top of the Home feed.
- Updated brand identity colors using:
  - Primary Brand: `#FF6A1A` (Modern & Bold)
  - Secondary Brand: `#FF7A2F` (Warm)
  - Accent Brand: `#FF5C00` (Strong Sports Identity)

### Changed
- Updated `SportSelector` and `TabBar` to use the new bold orange theme.
- Redesigned `GameCard` for dark mode with subtle white borders and low-contrast dividers.
- Fixed text readability across all screens for dark mode.
- Optimized bottom navigation to match the dark theme and brand colors.

## [1.0.0-alpha.3] - 2026-02-22 14:45

### Added
- Implemented "Yesterday, Today, Tomorrow" navigation tabs on the Home screen.
- Redesigned match cards with detailed information: abbreviations, league type, stadium, and broadcast channel.
- Added support for high-res transparent team logos from ESPN CDN.
- Integrated `flutter_svg` to support SVG assets.
- Added `selectedDate` to `AppState` with `SetSelectedDateAction` for tab-based date tracking.

### Changed
- Replaced basic game list with a Tab-based view for different match dates.
- Modernized timestamp and match status design with dynamic pill-shaped badges (Live/Final/Upcoming).
- Refined Home header to include the "Day of the Week" (e.g., SUNDAY) above the main date.
- Standardized score typography using tabular figures for better alignment.
- Switched default team logos to transparent PNGs to resolve rendering issues with complex SVGs.

### Fixed
- Resolved team logos appearing as black silhouettes by switching to optimized PNG assets.
- Improved layout consistency on different screen sizes using a more modular card design.

## [1.0.0-alpha.2] - 2026-02-22 11:30

### Updated
- Simplified Home header: removed notification bell, sport badges, and profile notification count.
- Project structure reorganization for better scalability (separated Data, Presentation, and Redux).
- Fixed "White screen" issue by flattening the widget tree.
- Resolved Xcode PIF transfer session error by clearing `DerivedData`.

## [1.0.0-alpha.1] - 2026-02-21 16:00

### Added
- Initial project setup with Flutter 3.3.
- Core architecture setup with directories: `lib/data`, `lib/presentation`, `lib/redux`, `lib/utils`.
- State management integration with `async_redux`.
- Local storage support with `sqflite` and `DatabaseHelper`.
- Modern UI implementation for Home (Your Arena).
- Initial data models (`Team`, `Game`).
- Light theme with `Figtree` font.

```
