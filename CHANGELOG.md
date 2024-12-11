# Change Log

All notable changes to this project will be documented in this file. This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a CHANGELOG](http://keepachangelog.com/).

## [unreleased] - unreleased

### Fixed


### Added


### Changed

- Use Alpine 3.20 as our base image ([PR #69](https://github.com/ponylang/changelog-bot-action/pull/69))

## [0.3.6] - 2024-10-16

### Fixed

- Handle Additional GitHub secondary rate limit failure ([PR #68](https://github.com/ponylang/changelog-bot-action/pull/68))

### Changed

- Alpine 3.18 ([PR #57](https://github.com/ponylang/changelog-bot-action/pull/57))

## [0.3.5] - 2023-02-09

### Fixed

- Update to work with newer versions of git ([PR #43](https://github.com/ponylang/changelog-bot-action/pull/43))

### Added

- Add sleep and retry when secondary rate limit impacts on PR search ([PR #46](https://github.com/ponylang/changelog-bot-action/pull/46))

## [0.3.4] - 2021-04-29

### Fixed

- Improve logging around multiple push attempts ([PR #35](https://github.com/ponylang/changelog-bot-action/pull/35))
- Fix build error caused by PyGitHub version dependencies changing ([PR #36](https://github.com/ponylang/changelog-bot-action/pull/36))

### Added

- Create images on release ([PR #37](https://github.com/ponylang/changelog-bot-action/pull/37))

## [0.3.3] - 2020-09-10

### Changed

- Rebase on pull ([PR #33](https://github.com/ponylang/changelog-bot-action/pull/33))

## [0.3.2] - 2020-08-31

### Fixed

- Fix failure when attempting push retries ([PR #32](https://github.com/ponylang/changelog-bot-action/pull/32))

## [0.3.1] - 2020-08-31

### Fixed

- Fix broken push retries ([PR #31](https://github.com/ponylang/changelog-bot-action/pull/31))

## [0.3.0] - 2020-08-26

### Changed

- Turn on branch.autorebasesetup when pushing/pulling ([PR #29](https://github.com/ponylang/changelog-bot-action/pull/29))

## [0.2.2] - 2020-08-15

### Added

- Retry push on failure ([PR #24](https://github.com/ponylang/changelog-bot-action/pull/24))

## [0.2.1] - 2020-06-06

### Fixed

- Fix bad action.yml ([PR #19](https://github.com/ponylang/changelog-bot-action/pull/19))

## [0.2.0] - 2020-05-17

### Changed

- Allow for the setting of git metadata associated with commits ([PR #17](https://github.com/ponylang/changelog-bot-action/pull/17))

## [0.1.2] - 2019-11-27

### Fixed

- $ handling in messages ([PR #12](https://github.com/ponylang/changelog-bot-action/pull/12))

## [0.1.1] - 2019-11-10

### Fixed

- Correctly work when there are no labels ([PR #11](https://github.com/ponylang/changelog-bot-action/pull/11))

## [0.1.0] - 2019-11-10

### Changed

- Switch to using changelog-tool to update CHANGELOG ([PR #8](https://github.com/ponylang/changelog-bot-action/pull/8))

## [0.0.2] - 2019-11-05

### Fixed

- Allow changelog-bot to work with forked repos ([PR #7](https://github.com/ponylang/changelog-bot-action/pull/7))

## [0.0.1] - 2019-10-31

### Added

- initial version

