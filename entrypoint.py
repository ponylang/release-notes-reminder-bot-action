#!/usr/bin/python3

import json,os,sys
from github import Github

changelog_labels = ['changelog - added', 'changelog - changed', 'changelog - fixed']

ENDC   = '\033[0m'
ERROR  = '\033[31m'
INFO   = '\033[34m'
NOTICE = '\033[33m'

if not 'API_CREDENTIALS' in os.environ:
  print(ERROR + "API_CREDENTIALS needs to be set in env. Exiting." + ENDC)
  sys.exit(1)

# get information we need from the event
event_data = json.load(open(os.environ['GITHUB_EVENT_PATH'], 'r'))
event_label = event_data['label']['name']
repo_name = event_data['repository']['full_name']
pr_number = event_data['pull_request']['number']
pr_opened_by = event_data['pull_request']['user']['login']

found_changelog_label = False
for cl in changelog_labels:
  if event_label == cl:
    found_changelog_label = True
    break

if not found_changelog_label:
  print(INFO + event_label + " isn't a changelog label. Exiting." + ENDC)
  sys.exit(0)

# get PR which is an "issue" for us because the GitHub API is weird
github = Github(os.environ['API_CREDENTIALS'])
repo = github.get_repo(repo_name)
issue = repo.get_issue(pr_number)

sentinel = "<!-- release-note-reminder-bot -->"

# check the existing comments for the sentinel.
found_sentinel = False
comments = issue.get_comments()

for c in comments:
  if sentinel in c.body:
    found_sentinel = True
    break

if found_sentinel:
  print(INFO + "Found existing comment sentinel. Exiting." + ENDC)
  sys.exit(0)

# don't post if there is already release notes included with the PR
found_release_notes_files = False
for f in repo.get_pull(pr_number).get_files():
    if f.status != "added":
      continue
    print(INFO + "Found file " + f.filename + ENDC)
    if f.filename.startswith('.release-notes/'):
      if not f.filename.endswith('next-release.md'):
        found_release_notes_files = True
        break

# if at least one release notes exists, exit
if found_release_notes_files:
  print(NOTICE + "Release notes file(s) found in commits. Exiting." + ENDC)
  sys.exit(0)

# ok, we should be posting. let's create a reminder and post it.
print(INFO + "Preparing release notes reminder comment." + ENDC)
comment_template = """{sentinel}
Hi @{user},

The {label} label was added to this pull request; all PRs with a changelog label need to have release notes included as part of the PR. If you haven't added release notes already, please do.

Release notes are added by creating a uniquely named file in the `.release-notes` directory. We suggest you call the file `{pr_number}.md` to match the number of this pull request.

The basic format of the release notes (using markdown) should be:

```
## Title

End user description of changes, why it's important,
problems it solves etc.

If a breaking change, make sure to include 1 or more
examples what code would look like prior to this change
and how to update it to work after this change.
```

Thanks.
"""

comment = comment_template.format(user=pr_opened_by, label=event_label,
  pr_number=str(pr_number), sentinel=sentinel)

print(INFO + "Posting comment." + ENDC)
issue.create_comment(comment)
