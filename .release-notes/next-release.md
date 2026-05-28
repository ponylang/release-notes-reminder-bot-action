## Use Alpine 3.18 as our base image

Previously we were using Alpine 3.16. This should have no impact on anyone unless they are using this image as the base image for another.

## Use Alpine 3.20 as our base image

Previously we were using Alpine 3.18 which has reached it's end-of-life. The change to 3.20 should have no impact on anyone unless they are using this image as the base image for another image.

## Fix intermittent failure to post release notes reminder

The bot could fail with an internal error while fetching pull request data, leaving the release notes reminder un-posted. The bot now handles those response cases gracefully and posts the reminder reliably.

