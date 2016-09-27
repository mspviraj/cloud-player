# Cloud Player
iOS application for streaming and editing music from Dropbox.

**Status**: In development.

**Functionalities:**
* :white_check_mark: Syncing songs (Device/Dropbox)
* :white_check_mark: Favorite songs
* :white_medium_square: Song metadata editor
* :white_medium_square: Album art finder
* :white_medium_square: Music player

### Configuration
Configuration files are located at this path: **Cloud Player/Supporting Files/**.

To be able to build and run project, create Dropbox API key (full access) and do steps below:
* Rename API-SAMPLE.plist to API.plist
  * Add Dropbox API key to this file for key "Dropbox"
* Rename Info-SAMPLE.plist to Info.plist. 
  * Add a Dropbox API key (format "db-DROPBOX_API_KEY") for key "CFBundleURLSchemes"

