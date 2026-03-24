## Retry when GitHub API doesn't immediately return PR for a commit

The GitHub Search API sometimes doesn't return PR results immediately after a merge event. Previously, the bot would see no results and exit, skipping the CHANGELOG update entirely. Now it retries up to 5 times with a 10-second delay, giving the API time to catch up.
