# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

* * *

## [Unreleased]

## [1.9.0] - 2026-01-08

- Updated to BoxLang 1.9.0
- <https://boxlang.ortusbooks.com/readme/release-history/1.9.0>

## [1.8.0] - 2025-12-05

- Updated to BoxLang 1.8.0
- <https://boxlang.ortusbooks.com/readme/release-history/1.8.0>

## [1.7.0] - 2025-11-04

- Updated to BoxLang 1.7.0
- <https://boxlang.ortusbooks.com/readme/release-history/1.7.0>

## [1.6.0] - 2025-10-03

- Updated to BoxLang 1.6.0
- <https://boxlang.ortusbooks.com/readme/release-history/1.6.0>

* * *

## [1.5.0] - 2025-08-30

### Updates

- Updated to BoxLang 1.5.0
- Updated the rewrite file to default to `index.bxm` when not set or empty

* * *

## [1.4.1] - 2025-08-08

### Fixed

- Fixed an issue where the `BOXLANG_MODULES` environment variable would throw an error when set due to a config collision

### Changed

- Add pre-dependendency install upgrades of packages to ensure latest security patches are applied

* * *

## [1.4.0] - 2025-08-02

### Added

- New BoxLang 1.4.0 support.
- New Quick Installer for BoxLang.
- Depandabot configuration for automatic dependency updates.
- Read versions from `version.json` file in GitHub Actions workflow.

### Fixed

- xTerm issues when running boxlang commands in the container.
- Fixed changelog merge issues.
- New script for installer to avoid helpers.sh issue.

* * *

## [1.3.0] - 2025-06-23

### Added

- BoxLang 1.3.0 support
- Update to use new quick installer
- Add secret expansions

* * *

## [1.2.0] - 2025-05-29

### Added

- New docs for all env variables
- Inline depdnency cleaning
- Added rewrites env variables: `REWRITES=true` and `REWRITES_FILE=index.cfm`
- Added min and max memory options: `max_memory` and `min_memory` which defaults to `-Xmx512m` and `-Xms512m` respectively.
- Added `JAVA_OPTS` environment variable to allow users to pass in custom Java options.
- Added `-Djava.awt.headless=true` to the Java options to ensure headless mode is enabled by default.

### Fixed

- Remove SSLPORT since MiniServer does not support SSL.
- BoxLang version was wrongly fixed at 1.0.0-snapshot for `snapshot`

* * *

## [1.1.1] - 2025-05-12

- Fixed docker compose typos.
- Updated to Boxlang 1.1.0.

* * *

## [1.1.0] - 2025-01-13

- Updated the install boxlang provider so it can use FORGEBOX.

* * *

## [1.0.0] - 2024-06-14

- First beta 1 release

* * *

[unreleased]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.9.0...HEAD
[1.9.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.8.0...v1.9.0
[1.8.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.7.0...v1.8.0
[1.7.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.6.0...v1.7.0
[1.6.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.4.1...v1.5.0
[1.4.1]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/ortus-boxlang/boxlang-docker/compare/v1.0.0...v1.0.0
