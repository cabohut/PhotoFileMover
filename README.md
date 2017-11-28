# PhotoFileMover
macOS app to rename photo file(s) using the photo date. The app also provides an option to move the file(s) to folders based on the creation date.

# Overview
I developed this app to help replace some of the functionality offered by Apple Aperture.
Aperture was great in managing new photo files with the following critical workflow steps:
 - Rename files based on the photo taken date, I typically used the format "YYYY-MM-DD - Filename.xxx"
 - After renaming the photo files I like to store them in year/month hirarchy
 
![alt text](https://github.com/cabohut/PhotoFileMover/blob/master/PhotoFileMover.png "PhotoFileMover Screen")

 # PhotoFileMover Workflow
  1. Select "Source Folder" and "Destination Folder"
  2. Optional - select "Recursive Search" to enable searching sub folders in the "Source Folder"
  3. Select "Move Files" to move the files after renaming them (from "Source Folder" to "Destination Folder")
  4. Select Subfolder options for the target "Destination Folder" - "None", "Year/Month", or "Year/Month/Day"
  5. Select renaming format - "None", "YYYY-MM-DD - Filename.xxx", or "MM-DD-YYYY - Filename.xxx"
  6. Optional - Enter opetional Exiftool parameters in the "Paramters" field
  7. Optional - Select "Test Only" if you want to test all the options without committing any changes
  8. Optional - Slect "Silent" mode to surpress the display of all the information steps displayed in the window on the bottom
  9. Select "Submit" when ready
 
 # Notes
 This app uses the python "sortphotos.py" script (https://github.com/andrewning/sortphotos).
 The script is used for processing the files and sortphotos.py uses Exiftool which is embedded in the sortpohotos source folder.
 
 The app expects the python executable to be available at "/usr/bin/python" (line 26 in the ViewController.swift files)
