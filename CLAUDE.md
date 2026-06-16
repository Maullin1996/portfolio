# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

This is a Flutter project (`portfolio`, SDK `^3.12.2`) currently at its initial scaffold: a single
entry point (`lib/main.dart`) rendering a placeholder "Hello World!" screen. Only the `web` platform
target has been generated so far (no `android`/`ios`/`windows`/`macos`/`linux` directories exist yet —
run `flutter create .` in the project root if a native target is needed). There is no `test/` directory
yet.

## Commands

- Install dependencies: `flutter pub get`
- Run the app (web, since that's the only generated platform): `flutter run -d chrome`
- Run on any connected/available device: `flutter run`
- Static analysis (uses `flutter_lints` via `analysis_options.yaml`): `flutter analyze`
- Run all tests: `flutter test`
- Run a single test file: `flutter test test/some_test.dart`
- Format code: `dart format .`
- Build for web: `flutter build web`

## Architecture

- `lib/main.dart` is the sole source file: `main()` calls `runApp(const MainApp())`, where `MainApp` is
  a `StatelessWidget` returning a `MaterialApp` → `Scaffold`. As the app grows, new widgets/screens
  should be added as additional files under `lib/` rather than growing `main.dart` directly.
- Linting follows the standard `flutter_lints` recommended rule set with no project-specific overrides.
