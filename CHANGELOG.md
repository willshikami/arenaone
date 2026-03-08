# Changelog

All notable changes to the Arena One project will be documented in this file.

## [1.0.0-alpha.12] - 2026-03-04

### Added
- **Live Clock Engine**: Implemented a stateful real-time ticker for NBA and Football cards that provides a live countdown (NBA) or count-up (Football) experience in between API syncs.
- **Football Stoppage Time**: Native support for stoppage time in Football cards (e.g., `45 +1:23` and `90 +3:45`) for realistic match tracking.
- **Enhanced NBA Status Mapping**: Numeric `period` field now dynamically displays quarters (e.g., `1ST QTR`, `2ND QTR`) with a neutral orange theme for Halftimes.
- **Centralized Asset Management**: Created `AppAssets` to load all sports category logos from local high-quality PNGs, replacing generic icons.
- **Live Feed "Show More" CTA**: Dynamic "Show X more" text in the Live tab for categories with more than 5 ongoing events.

### Changed
- **Modernized Card Layout**: Restructured NBA and Football cards to prioritize team names and scores at the top, moving metadata (venue/status) and a divider line to the bottom for a cleaner aesthetic.
- **Simplified Navigation**: Removed the "Scores" tab and updated the Home icon to `sf_sportscourt` for a leaner, more centered experience.
- **Refined Typography**: Standardized uppercase headers and reduced font sizes for game clocks and status badges to improve visual hierarchy and professional feel.
- **Logo Optimization**: Removed circular clipping and borders from team logos to ensure they display in their natural aspect ratio without being cut off.

### Fixed
- **NBA Halftime Visibility**: Fixed a bug where the game clock would remain visible during Halftimes; it is now correctly replaced by the "HALFTIME" status.
- **Date Header Alignment**: Modernized the Home screen header by removing "Today" and far-left aligning the day name in bold uppercase.

### Fixed
- **Live ActivityKit Error**: Resolved `PlatformException(LIVE_ACTIVITY_ERROR, can't launch live activity, ...)` by ensuring the payload matches the SwiftUI widget's expected structure and updating plugin usage.
- **Back Button Overlap**: Fixed layout bug where the back button would overlap with header information on scroll.
- **Column Title Alignment**: Table headers now always align with player columns, regardless of device width or scroll state.

## [1.0.0-alpha.10] - 2026-02-26

### Added
- **iOS Live Activities**: Fully implemented ActivityKit integration for real-time score tracking on Lock Screen and Dynamic Island.
  - Added `LiveActivityService` for Flutter-to-Native communication.
  - Created specialized Swift UI (`ArenaOneWidgetLiveActivity.swift`) for native iOS widgets.
  - Support for Football, NBA, and Golf live tracking.
- **Silent Background Refresh**: Added a 3-minute periodic timer to `HomeScreen` that updates scores without showing shimmers, providing a seamless live experience.
- **Flip-Down Animations**: Implemented a 3D "Flip-down" effect for score updates in `GameCard` to make value changes feel tactile and non-jarring.
- **Shimmer Skeletons**: Created custom loading skeletons for all sport types (F1, NBA, Football, Golf, Rally) to match specific card geometries.

### Changed
- **Data Fidelity**: Removed all mock and placeholder data. The app now fetches exclusively from Supabase, with automatic fail-safe mappings for different sport types.
- **State Management**: Enhanced `LoadAllGamesAction` to support background parallel fetches, significantly reducing UI "blinking" during refreshes.

## [1.0.0-alpha.9] - 2026-02-25 15:30

### Added
- **Onboarding Experience**: Introduced a high-fidelity `SportSelectionPage` grid that allows new users to follow their favorite sports on first launch.
- **Following Management**: Replaced the "Following" placeholder with a live sync grid, allowing users to update their feed preferences at any time.
- **Persistent Storage**: Integrated `sqflite` for local data persistence, ensuring user sport selections and settings survive app restarts.
- **Profile & Settings**: Created a new `ProfilePage` featuring:
  - User bio section with an "Edit Profile" action button.
  - "Live Activities" toggle with state persistence (tracked via Redux and SQLite).
  - Streamlined preferences layout with unified card design.
- **Premier League Support**: Added specialized horizontal `FootballCard` logic featuring circular SVG team logos and match-specific minute indicators.

### Changed
- **Navigation Architecture**:
  - Simplified the bottom navigation to a 4-tab system: **Home**, **Scores**, **Following**, and **Profile**.
  - Removed the "Explore" tab to focus on personalized content.
  - Connected navigation to Redux for robust tab switching across different screens.
- **Visual Improvements**:
  - Implemented a global `RadialGradient` background for a premium "dark mode glow" effect.
  - Standardized horizontal padding to 24px across all main pages.
  - Cleaned up the `HomeTopBar` by removing redundant settings icons now accessible via the Profile tab.
- **Code Architecture**:
  - Refactored the `Game` model into an `abstract` polymorphic class system.
  - Replaced boilerplate code-generation with a manual factory pattern for better handling of diverse sport types.
  - Optimized Redux actions for better async performance and database synchronization.

### Fixed
- Resolved serialization issues with polymorphic sport models.
- Fixed `SFIcons` reference errors and improved icon fallback logic.
- Cleaned up unused imports and obsolete generated files (`game.g.dart`).

## [1.0.0-alpha.8] - 2026-02-24 10:15

### Added
- **Tab-Based Navigation**: Introduced "Upcoming", "Live", and "Results" tabs on the home screen for better event categorization.
- **Sport Category Pages**: Created a new `SportCategoryPage` allowing users to see all events for a specific sport and status, accessible via a new "SHOW MORE" button.
- **Date-Based Grouping**: Events on sport category pages are now grouped by date (Today, Yesterday, Tomorrow, etc.).
- **F1 Live Card**: Specialized live racing card featuring leader tracking (name, team, image, lap info) and real-time P2/P3 gaps.

### Changed
- **Homepage Structure**:
  - Substituted sport selector chips for the new tab system.
  - Events are now grouped by sport with `Space Mono` titles and `SFIcons`.
  - Curated the homepage to show a maximum of two events per sport category.
- **Standardized Card Headers**:
  - Standardized "Upcoming" event cards for Basketball, Tennis, Golf, and Rally to match F1's premium layout (League/Round on left, Date and formatted Time Box on right).
  - Moved NBA "LIVE" indicator to the header, removing clutter from the center score area.
- **Enhanced Results Visuals**:
  - Implemented automatic winner detection for NBA games with bold highlighting and victory checkmarks.
  - Expanded F1, Golf, and Rally results to always display the top 3 podium finishers with gap times and metadata.
- **Improved Data Fidelity**: Updated mock data with high-resolution headshots for Tennis players and more comprehensive event stats for all sports.

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
