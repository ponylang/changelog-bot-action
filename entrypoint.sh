#!/bin/sh -l

cat "${GITHUB_EVENT_PATH}"
# Get commit SHA from PushEvent
SHA=$(jq '.payload.head' "${GITHUB_EVENT_PATH}")
REPO=$(jq '.repo.name' "${GITHUB_EVENT_PATH}")

# Search for merged PR featuring our SHA in our REPO
echo "Running changelog bot for ${SHA} in ${REPO}"
PR_URL=$(curl -s "https://api.github.com/search/issues?q=is:merged+sha:${SHA}+repo:${REPO}" | jq -r '.items[].pull_request.url')

if [[ -z PR_URL ]]; then
  echo -e "\e[33mNo PR associated with ${SHA}. Exiting."
  exit 0
fi

# We have a PR url, let's fetch it.
curl -s "${PR_URL}" >> pr.json

# Extract information from pull request
BASE_BRANCH=$(jq -r '.base.ref' pr.json)
PULL_REQUEST_TITLE=$(jq -r '.title' pr.json)
PULL_REQUEST_NUMBER=$(jq -r '.number' pr.json)
COMMIT_MESSAGE="Update CHANGELOG for PR #${PULL_REQUEST_NUMBER} [skip ci]"
CHANGELOG_ENTRY="- ${PULL_REQUEST_TITLE} ([PR #${PULL_REQUEST_NUMBER}](${PULL_REQUEST_URL}))"

CHANGELOG_TYPES=$(
  cat pr.json |
  jq -r '.labels | map(.name) | join("'"$IFS"'")' |
  grep 'changelog - ' |
  grep -o -E 'added|changed|fixed' |
  awk '{$1=toupper(substr($1,0,1))substr($1,2)}1' # capitalize the first letter
)
# git setup
# Set up .netrc file with GitHub credentials
cat <<- EOF > $HOME/.netrc
      machine github.com
      login $GITHUB_ACTOR
      password $GITHUB_TOKEN
      machine api.github.com
      login $GITHUB_ACTOR
      password $GITHUB_TOKEN
EOF

chmod 600 $HOME/.netrc

git config --global user.name 'Ponylang Main Bot'
git config --global user.email 'ponylang.main@gmail.com'

# make sure we are up to date
git checkout "${BASE_BRANCH}"
git pull

for CHANGELOG_TYPE in $CHANGELOG_TYPES; do
  CHANGELOG_HEADER="### ${CHANGELOG_TYPE}"
  perl -i -ne "BEGIN{$/ = undef;} s@(${CHANGELOG_HEADER}\s*)@\1${CHANGELOG_ENTRY}\n@; print" CHANGELOG.md
done

# Add CHANGELOG changes and commit
git add CHANGELOG.md
git commit -m "$COMMIT_MESSAGE"

# Now we want to be quiet - don't want to print the GITHUB_TOKEN var.
set +x

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "GITHUB_TOKEN environment variable is missing - add it as a secret!"
  exit 1
fi

# push those changes son
git push
