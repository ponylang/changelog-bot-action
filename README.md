# Changelog-bot action

Automatically adds a new changelog entry to a Pony project standard format CHANGELOG once a PR is merged. One of 3 labels must be applied to the PR in order for a CHANGELOG entry to be added:

- changelog - added
- changelog - fixed
- changelog - changed

See the Pony [changelog-tool](https://github.com/ponylang/changelog-tool) for additional information on standard Pony project formats.

## Example workflow

```yml
name: Changelog Bot

on:
  push:
    branches:
      - '**'
    tags-ignore:
      - '**'
    paths-ignore:
      - CHANGELOG.md

jobs:
  changelog-bot:
    runs-on: ubuntu-latest
    name: Update CHANGELOG.md
    steps:
      - name: Update Changelog
        uses: ponylang/changelog-bot-action@0.2.2
        with:
          git_user_name: "Ponylang Main Bot"
          git_user_email: "ponylang.main@gmail.com"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Note, you do not need to create `GITHUB_TOKEN`. It is already provided by GitHub. You merely need to make it available to the Changelog-bot action.
