#!/bin/bash

set -e

if [[ -z "${API_CREDENTIALS}" ]]; then
  echo -e "\e[31mAPI_CREDENTIALS needs to be set in env. Exiting.\e[0m"
  exit 1
fi

#
# Get label and see if it is a changelog label.
# If it isn't a changelog label, let's exit.
#

CHANGELOG_LABEL=$(
  jq -r '.label.name' ${GITHUB_EVENT_PATH} |
  grep 'changelog - ' |
  grep -o -E 'added|changed|fixed' ||
  true
)

if [ -z ${CHANGELOG_LABEL} ];
then
  echo -e "\e[34m${CHANGELOG_LABEL} isn't a changelog label. Exiting.\e[0m"
  exit 0
fi

COMMENTS_LINK=$(jq -r '.pull_request._links.comments.href' ${GITHUB_EVENT_PATH})
OPENED_BY=$(jq -r '.pull_request.user.login' ${GITHUB_EVENT_PATH})

# Prepare comment
echo -e "\e[34mPreparing release notes reminder comment...\e[0m"
body="@${OPENED_BY},

It looks like this Pull Request requires release notes to be included.
If you haven't added them already, please do.

Thanks!
"

jsontemplate="
{
  \"body\":\$body
}
"
json=$(jq -n \
--arg body "$body" \
"${jsontemplate}")

# Add comment
echo -e "\e[34mAdding release note reminder...\e[0m"

result=$(curl -s -X POST "${COMMENTS_LINK}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -u "${API_CREDENTIALS}" \
  --data "${json}")

rslt_scan=$(echo "${result}" | jq -r '.id')
if [ "$rslt_scan" != null ]
then
  echo -e "\e[34mComment posted\e[0m"
else
  echo "\e[31mUnable to post comment, here's the curl output...\e[0m"
  echo "${result}"
  exit 1
fi
