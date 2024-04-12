# Change Log

All notable changes to this project will be documented in this file.
`Gauntlet` adheres to [Semantic Versioning](https://semver.org/).

## main

Unreleased changes

#### Breaking Changes

#### Added

#### Updated

#### Fixed

## 2.2.0

#### Updated
- Updated for Sendable conformance.

## 2.1.0

#### Added
- Added a `contains` operator for Collections.

## 2.0.0

#### Breaking Changes
- Removed deprecated async APIs.
- Existing Gauntlet API has been moved to a new GauntletLegacy target.

#### Added
- Added new functional Assertion API.

## 1.1.0

#### Added
- Add `XCTAwaitAssertEqual`
- Add `XCTAwaitAssertNotNil`
- Add `XCTAwaitAssertFalse` and `XCTAwaitAssertTrue`

#### Deprecated
- `XCTAssertNoThrow` in favor of `XCTAwaitAssertNoThrow`
- `XCTAssertThrowsError` in favor of `XCTAwaitAssertThrowsError`

## 1.0.0

First release as open source.

#### Added

- Initial release of Gauntlet as open source.
