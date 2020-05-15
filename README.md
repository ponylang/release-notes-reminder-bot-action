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
          API_CREDENTIALS: "${{ secrets.GITHUB_ACTOR }}:${{ secrets.GITHUB_TOKEN }}"
```

API_CREDENTIALS can be of two forms. If you would like to post the release
notes reminder comment as a specific user, then create a personal access token
as that user and set API_CREDENTIALS to the token value.

If you are ok with the comment being posted as "GitHub Bot" then you can set
API_CREDENTIALS to `"${{ secrets.GITHUB_ACTOR }}:${{ secrets.GITHUB_TOKEN }}"`.
You do not need to supply GITHUB_ACTOR nor GITHUB_TOKEN as they are supplied by
the GitHub actions environment already.
