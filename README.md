# Changelog-bot action

## Example workflow

```yml
on:
  pull_request:
    types: [closed]

jobs:
  changelog-bot:
    runs-on: ubuntu-latest
    name: Update CHANGELOG.md
    steps:
      - uses: actions/checkout@v1
      - name: Update Changelog if applicable
        uses: ponylang/changelog-bot-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Note, you do not need to create `GITHUB_TOKEN`. It is already provided by GitHub. You merely need to make it available to the Changelog-bot action.
