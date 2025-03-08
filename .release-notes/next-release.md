## Fix "it no longer works" bug

A few days ago, the Python library we use to interact with GitHub started telling us all searches we did had 0 results even when they didn't. Nothing had changed with the library. Nothing had changed with GitHub's responses. This had all worked for years. And then it didn't.

Upgrade to the new version of this action immediately.

## Use Alpine 3.20 as our base image

Previously we were using Alpine 3.18 which has reached it's end-of-life. The change to 3.20 should have no impact on anyone unless they are using this image as the base image for another image.
