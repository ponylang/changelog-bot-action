#!/bin/sh -l


PULL_REQUEST_MERGED=$(jq '.pull_request.merged' "${GITHUB_EVENT_PATH}")
if [[ "true" != "$PULL_REQUEST_MERGED" ]]; then
  echo "Ignoring not-merged pull request"
  exit 0
fi

PULL_REQUEST_TITLE=$(jq -r '.pull_request.title' "${GITHUB_EVENT_PATH}")
PULL_REQUEST_NUMBER=$(jq -r '.number' "${GITHUB_EVENT_PATH}")
COMMIT_MESSAGE="Update CHANGELOG for PR #${PULL_REQUEST_NUMBER} [skip ci]"
CHANGELOG_ENTRY="- ${PULL_REQUEST_TITLE} ([PR #${PULL_REQUEST_NUMBER}](${PULL_REQUEST_URL}))"

CHANGELOG_TYPES=$(
  cat "${GITHUB_EVENT_PATH}" |
  jq -r '.pull_request.labels | map(.name) | join("'"$IFS"'")' |
  grep 'changelog - ' |
  grep -o -E 'added|changed|fixed' |
  awk '{$1=toupper(substr($1,0,1))substr($1,2)}1' # capitalize the first letter
)

for CHANGELOG_TYPE in $CHANGELOG_TYPES; do
  CHANGELOG_HEADER="### ${CHANGELOG_TYPE}"
  perl -i -ne "BEGIN{$/ = undef;} s@(${CHANGELOG_HEADER}\s*)@\1${CHANGELOG_ENTRY}\n@; print" CHANGELOG.md
done

git config --global user.name 'Ponylang Main Bot'
git config --global user.email 'ponylang.main@gmail.com'
git add -A && git commit -m "$COMMIT_MESSAGE" --allow-empty

# Now we want to be quiet - don't want to print the GITHUB_TOKEN var.
set +x

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "GITHUB_TOKEN environment variable is missing - add it as a secret!"
  exit 1
fi

git remote add origin-token "https://$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git" > /dev/null 2>&1
git push -u origin-token HEAD > /dev/null 2>&1
