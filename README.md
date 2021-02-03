# curling_simulator
 
This is the software that accomodates the curling simulator described in the YouTube playlist https://www.youtube.com/channel/UCX1GRaxY0jyaBjtAbMWFnZA. You are welcome to download it and check it out, but the install process may not be for the faint of heart, and may not even be possible for all operating systems. No attempt has been made to optimize the code or beautify it beyond the point where it works pretty well on the limited number of machines we have tried. This work is presented as-is, with no implied commitment to provide fixes, improvements or support.

### Instructions

The instructions below are specifically geared toward installation on a Mac, as that represents the entire sum of our current experience.  Windows or Linux installations should have similar but not identical steps.  Older machines with limited processor speeds may exhibit degraded and/or unacceptably slow performance.

*** Note to users who have already upgraded to MacOS BigSur: as of this writing, the installation of the Processing app (see below) on your machine, in such a way that the camera operates properly, involves a series of steps that is beyond the scope of this write-up. See https://github.com/processing/processing4 if you're really ambitious, and expect to suffer.

#### 1. Install Processing
This code runs on the Processing platform and requires the user to download and install Processing (processing.org/download).  Download the version for your operating system, unzip the folder, and move the Processing.app file to a good place on your computer, commonly the Applications folder.

#### 2. Download Github files 
Go to github.com/hackinshack/curling_simulator_2 and hit the green "Code" button in the upper right of the repository.  Download the zip file containing the code, unzip it, and rename the unzipped folder "curling_simulator_2" (removing the -main extension).

#### 3. Load the program
Move the curling_simulator_2 folder to the location that Processing uses as its "Sketchbook" folder.  This is typically Documents/Processing on the Mac.  

Inside the curling_simulator_2 folder is another folder called "CurlingSimulatorLibrary".  Move this folder into Documents/Processing/libraries.  

Run the Processing app (double-click the icon in the Applications folder). When it opens, choose File->Sketchbook->curling_simulator_2 from the menu.  This will open the curling simulator software, if you've completed the above steps successfully.  

#### 4. Install "minim" audio library
Select Sketch->Import Library->Add Library from the menu options.  Search for "minim" in the search box.  Select "Minim | An audio library ..." and click "Install".

#### 5. Run the curling simulator
If all goes well, you can now click the arrow button in the top left corner of the sketch to run it.  The program may take a minute or two to load and emerge from a gray screen.  You may be prompted to allow use of the camera -- this may happen automomatically or you may have to manually set your permissions to allow Processing to access the camera in order for the program to run. 

#### 6. Useful code edits
To enable full screen mode, click on the "curling_simulator_2" tab of the code and scroll down to the "setup()" function.  Comment out the line "size(1280,800,P3D)" and uncomment the line "fullScreen(P3D)". Performance may be degraded for older machines in fullscreen mode.

If the appearance of the "views" inside the main application window seems too small or large, you can adjust the relative size of those views. Go to the "GUI" tab in the code.  The first class is the "SettingsController" class, which has a variable called "standard_block_size", set to 160 initially.  Adjusting this variable up or down makes the relative view size larger or smaller, respectively.

#### 7. Enjoy
If you've made it this far and actually got it to work, congratulations! We would love to compare notes with anyone setting up a simulator of their own.
