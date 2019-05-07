################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                           Day 0 - The intRoduction                           #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

# Learn the basics of git from strangers on youtube
browseURL("https://www.youtube.com/watch?v=OqmSzXDrJBk")

# If you want, download a GUI option for GitHub
browseURL("https://desktop.github.com/")

# Setup git on your computer
system('git config --global user.name "Your Name"')
system('git config --global user.email your-email-address@osu.edu')

# Go to your home (aka, user) directory (aka, folder) and make a directory
# for storing your git repos (or just go there if you already have one)
system('cd ~')  # or just 'cd' without a folder name, which does the same thing...
                # If you're in Windows CMD, it should open your terminal to the home
                # directory from the start, but if not, use:
system('cd Users\<your-computer-username>')  # And the <...> is just a placeholder,
                                   # don't type it in when you're executing locally...

# Then, make the new 'git' directory with 'mkdir' and navigate into it with 'cd'
system('mkdir git')
system('cd git')

# List the contents of your current folder (git/) with 'ls'
system('ls')  # In windows CMD, use 'dir' instead
              # If you just made the folder, you should see no files, 
              # folders, or anything

# Get a copy of the repo for this course; if you do this while in your 'git' folder,
# it will make a new subfolder with the same name as the repo. So, in our case:
#   ~/git/bootcampr
system('git clone https://github.com/collinmmccabe/bootcampr')
system'(cd bootcampr')

# You should be in the master branch by default, but let's each make our own
system('git branch student/<your-github-username>')
system('git checkout student/<your-github-username>')

# Now open up your computer's file navigator, go to your repo, in the 
# 'day00' folder, and make a new file called 'my_notes.R'
#   (Or, just go to the 'day00' folder in Rstudio and make a new R file)
    
# When we get back to git, if we want to track these changes, we need to add
# the file - we can see this when we run status to see the tracking status of files
system('git status')

# So, we add the file to the tracked ones with:
system('git add my_notes.R')
system('git status')

# And if we want to "save" our progress, we will need to make a commit, with a message
system('git commit -m "This is my first commit for the R bootcamp"')

# Then view all the commits that make up your repo with 'git log'
system('git log')

# After I've made changes to course material, you need to first check and see what
# has changed on my master branch; you can do this with:
system('git checkout master')
system('git fetch origin')

# Then, we can actually download these changes with:
system('git pull')

# But all of the changes that I will make will be going directly into the master
# branch, which is kindaq off limits to all of you (for safety purposes).
# To incorporate my changes, let's first make sure that you're in your branch:
system('git checkout student/<your-github-username>')

# And then we'll merge master into your current branch
system('git merge master')

# Et voila, you have the newest version of the course materials :)
# ...once you email me your GitHub username, I will add you as a collaborator,
# and then you'll be allowed to 'push' your own changes on your 'local' branch up to a
# a 'remote' version of your branch on my repo (kinda like saving it to the cloud)
system('git push -u origin student/<your-github-username>')  # '-u' tells git to
                                                             # make an upstream branch