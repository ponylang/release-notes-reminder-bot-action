# Release-notes-reminder-bot action

Bot to remind that release notes are needed when a CHANGELOG label is added to a PR  One of 3 labels must be applied to the PR in order to trigger a reminder.

- changelog - added
- changelog - fixed
- changelog - changed

## Example workflow

```yml
name: Release Notes Reminder Bot

on:
  pull_request:
    types: [labeled]

jobs:
  release-note-reminder-bot:
    runs-on: ubuntu-latest
    name: Prompt to add release notes
    steps:
      - name: Prompt to add release notes
        uses: ponylang/release-notes-reminder-bot-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Note, you do not need to create `GITHUB_TOKEN`. It is already provided by GitHub. You merely need to make it available to the Changelog-bot action.
