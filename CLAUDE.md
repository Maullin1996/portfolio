# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

This is a Flutter web portfolio (`portfolio`, SDK `^3.12.2`), a single-page scrolling site styled
entirely with the author's own design system, [`atomic_design`](https://github.com/Maullin1996/atomic_design.git)
(pulled as a git dependency in `pubspec.yaml`, not a local path dependency). Only the `web` platform
target has been generated (no `android`/`ios`/`windows`/`macos`/`linux` directories — run
`flutter create .` in the project root if a native target is ever needed). A `test/` directory exists
with widget tests for each section.

The site auto-deploys to GitHub Pages via `.github/workflows/deploy.yml`.

## Commands

- Install dependencies: `flutter pub get`
- Run the app (web, since that's the only generated platform): `flutter run -d chrome`
- Static analysis (uses `flutter_lints` via `analysis_options.yaml`): `flutter analyze`
- Run all tests: `flutter test`
- Run a single test file: `flutter test test/some_test.dart`
- Format code: `dart format .`
- Build for web: `flutter build web`

## Architecture

- `lib/main.dart` calls `AtomicDesignConfig.initializeFromAsset('assets/config/app_config.json')` before
  `runApp(const PortfolioApp())`. `PortfolioApp` (`lib/app.dart`) owns a `ThemeController`
  (`lib/theme/theme_controller.dart`, a `ValueNotifier<ThemeMode>`) and builds the `MaterialApp`.
- **`AppThemeProvider` gotcha**: it must be wired via `MaterialApp.builder` (wrapping the Navigator +
  Overlay) rather than wrapping `MaterialApp` or being passed only to `home`. `home` only wraps the
  initial route's content, so dialogs pushed via `showDialog` (e.g. the Proyectos demo video dialog)
  live in the Overlay and can't see a provider scoped to `home` alone. Don't move this back to `home:`
  or to wrapping `MaterialApp` — see `lib/app.dart` for the full note.
- **Single-page scroll, not multi-route**: sections live under `lib/sections/` (`hero_section.dart`,
  `projects_section.dart`, `about_section.dart`, `experience_section.dart`, `contact_section.dart`),
  each registered in the `PortfolioSection` enum (`lib/layout/portfolio_section.dart`), which defines
  both scroll order and nav bar/drawer link order. `lib/layout/portfolio_shell.dart` holds a `GlobalKey`
  per section and scrolls to it via `Scrollable.ensureVisible`.
- **Responsive breakpoints**: `lib/layout/breakpoints.dart` mirrors `atomic_design`'s token breakpoints
  (small/medium/large/xLarge) for visual consistency, but `navCollapse` (nav bar → hamburger threshold)
  is intentionally decoupled from `large` (600px) and set to `xLarge` (840px) — five nav links + brand +
  theme toggle overflow below 840px (confirmed: "Contacto" collides with the theme icon under 748px, icon
  pushed off entirely by ~653px). Don't lower `navCollapse` back to `large`.
- Data models for content (projects, work experience, skills, contact links) live under `lib/models/`.
- `lib/widgets/reveal_on_scroll.dart` provides the scroll-reveal animation used by sections; `nav_bar.dart`
  is the responsive nav (top bar ≥840px, hamburger + drawer below).
- New widgets/screens should be added as additional files under `lib/`, grouped into the existing
  `layout/`, `models/`, `sections/`, `theme/`, `widgets/` folders by role.
- Linting follows the standard `flutter_lints` recommended rule set with no project-specific overrides.

## Known gaps

- Scroll-spy nav highlighting (highlighting the active section's nav link while scrolling) is not yet
  implemented.
