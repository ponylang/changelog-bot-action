## Fix broken push retries

Previously, we added a retry to a failed push where we would pull the latest changes and then push again. However, this didn't work as the wrong exception was being caught.
