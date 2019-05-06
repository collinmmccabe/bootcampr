# GUI option for GitHub
https://desktop.github.com/

# git basics
https://www.youtube.com/watch?v=OqmSzXDrJBk

# Setup git on your computer
git config --global user.name "Your Name"
git config --global user.email your-email-address@osu.edu

# Make a directory for storing your git repos (or just go there if you already have one)
mkdir /Users/<your-computer-username>/git
cd /Users/<your-computer-username>/git

# Get a copy of the repo for this course
git clone https://github.com/collinmmccabe/bootcampr
cd bootcampr

# You should already be in the master branch, but let's each make our own
git branch student/<your-github-username>
git checkout student/<your-github-username>

# Now open up your file navigator, go to your repo, in the 'day00' folder, 
# and make a new file called 'my_notes.R'
    
# When we get back to git, if we want to track these changes, we need to add
# the file - we can see this when we run status to see the tracking status of files
git status

# So, we add the file to the tracked ones with:
git add my_notes.R
git status

# And if we want to "save" our progress, we will need to make a commit, with a message
git commit -m 'This is my first commit for the R bootcamp'

# After I've made changes to course material, you need to first check and see what
# has changed on my master branch; you can do this with:
git checkout master
git fetch origin

# Then, we can actually download these changes with:
git pull

# But all of the changes that I will make will be going directly into the master
# branch, which is kindaq off limits to all of you (for safety purposes).
# To incorporate my changes, let's first make sure that you're in your branch:
git checkout student/<your-github-username>

# And then we'll merge mast into your current branch
git merge master

# Et voila, you have the newest version of the course materials :)
# ...once you email me your GitHub username, I will add you as a collaborator,
# and then you'll be allowed to 'push' your own changes on your 'local' branch up to a
# a 'remote' version of your branch on my repo (kinda like saving it to the cloud)

# Rstudio interface intro
https://youtu.be/pXd54-vucu0?t=219 (Watch from 3:39 to 16:18)
