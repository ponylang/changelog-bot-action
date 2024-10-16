#!/usr/bin/python3
# pylint: disable=C0103
# pylint: disable=C0114

import time
import json
import os
import re
import subprocess
import sys
import git
from git.exc import GitCommandError
from github import Github
from github.GithubException import RateLimitExceededException
from github.GithubException import GithubException

CHANGELOG_LABELS = ['changelog - added',
                    'changelog - changed',
                    'changelog - fixed']

ENDC = '\033[0m'
ERROR = '\033[31m'
INFO = '\033[34m'
NOTICE = '\033[33m'

if 'GITHUB_TOKEN' not in os.environ:
    print(ERROR + "GITHUB_TOKEN needs to be set in env. Exiting." + ENDC)
    sys.exit(1)

# login
github = Github(os.environ['GITHUB_TOKEN'])

# get json data for our event
event_data = ""
with open(os.environ['GITHUB_EVENT_PATH'], 'r', encoding='utf-8') as f:
    event_data = json.load(f)

# grab info needed to find PR
sha = event_data['head_commit']['id']
repo_name = event_data['repository']['full_name']

# find associated PR (if any)
print(INFO + "Finding PR associated with " + sha + " in " + repo_name + ENDC)
query = "q=is:merged+sha:" + sha + "+repo:" + repo_name
print(INFO + "Query: " + query + ENDC)
pr_id = 0
search_failures = 0
while True:
    try:
        results = github.search_issues(query='is:merged', sha=sha,
                                       repo=repo_name)

        if results.totalCount == 0:
            print(NOTICE + "No merged PR associated with " + sha + ". Exiting.")
            sys.exit(0)

        pr_id = results[0].number
        print(INFO + "PR found " + str(pr_id) + ENDC)
        break
    except RateLimitExceededException:
        search_failures += 1
        if search_failures <= 5:
            print(NOTICE
                  + "Search failed due to rate limit exceeded. "
                  + "Sleeping and trying again."
                  + ENDC)
            time.sleep(30)
        else:
            print(ERROR + "Search failed again. Giving up." + ENDC)
            raise
    except GithubException as e:
        if "You have exceeded a secondary rate limit" in e.data['message']:
            search_failures += 1
            if search_failures <= 5:
                print(NOTICE
                    + "Search failed due to secondary rate limit exceeded. "
                    + "Sleeping and trying again."
                    + ENDC)
                time.sleep(30)
            else:
                print(ERROR + "Search failed again. Giving up." + ENDC)
                raise
        else:
            raise

repo = github.get_repo(repo_name)
pull_request = repo.get_pull(pr_id)

# check to make sure that the PR had at least one changelog label
pr_changelog_labels = []
for l in pull_request.labels:
    print(INFO + "PR had label: " + l.name + ENDC)
    if l.name in CHANGELOG_LABELS:
        pr_changelog_labels.append(l.name)

if not pr_changelog_labels:
    print(NOTICE
          + "No changelog labels associated with PR #"
          + str(pr_id)
          + ". Exiting."
          + ENDC)
    sys.exit(0)

print(INFO + "Cloning repo." + ENDC)
clone_from = "https://" + os.environ['GITHUB_ACTOR'] \
              + ":" + os.environ['GITHUB_TOKEN'] \
              + "@github.com/" \
              + repo_name
pr_base_branch = pull_request.base.ref
clone_options = ["--branch=" + pr_base_branch]
git = git.Repo.clone_from(clone_from, '.', multi_options=clone_options).git

print(INFO + "Setting up git configuration." + ENDC)
git.config('--global', 'user.name', os.environ['INPUT_GIT_USER_NAME'])
git.config('--global', 'user.email', os.environ['INPUT_GIT_USER_EMAIL'])
git.config('--global', 'branch.autosetuprebase', 'always')
git.config('--global', '--add', 'safe.directory', os.environ['GITHUB_WORKSPACE'])

# construct changelog_entry
pull_request_title = pull_request.title
pr_html_url = pull_request.html_url
changelog_entry = pull_request_title \
                  + " ([PR #" + str(pr_id) \
                  + "](" \
                  + pr_html_url \
                  + "))"

print(INFO + "Updating CHANGELOG.md." + ENDC)
for prcl in pr_changelog_labels:
    change_type = re.sub('changelog - ', '', prcl)
    subprocess.call(['changelog-tool',
                     'add',
                     change_type,
                     changelog_entry,
                     '-e'])

print(INFO + "Adding git changes." + ENDC)
git.add('CHANGELOG.md')
git.commit('-m', "Update CHANGELOG for PR #" + str(pr_id))

push_failures = 0
while True:
    try:
        print(INFO + "Pushing changes." + ENDC)
        git.push()
        break
    except GitCommandError:
        push_failures += 1
        if push_failures <= 5:
            print(NOTICE
                  + "Failed to push. Going to pull and try again."
                  + ENDC)
            git.pull(rebase=True)
        else:
            print(ERROR + "Failed to push again. Giving up." + ENDC)
            raise
