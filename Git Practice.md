1.  Log into Gitlab
    
2.  Click "New Project" at the top right 
    
3.  Click Create Blank Project 
    
4.  Give your project a name 
    
5.  Under project URL select your namespace 
    
6.  Leave all the other settings as defaults 
    
7.  Create the project 
    
8.  You will now have a project with a README.md file in it, which is all you need to practice using git commands 
    
9.  First you will clone this repository to your "local" which will be WSL for most people. 
    
10.  In Gitlab click the blue clone button and copy the SSH url  
    
11.  Log onto WSL and run the git clone command to create a local copy of the repository git clone  
    
12.  You should see an output in the terminal similar to this  If you see an error talking about Possible DNS Spoofing, this means you've done a clone previously before gitlab was moved to Azure. Run the ssh-keygen command that is in the message, rerun the git clone, and accept the new trusted host. 
    
13.  Change directory into your project cd git-practice 
    
14.  Run an ls to see the README in the directory ls 
    
15.  Type: `git status` 
    
16.  It will show you that you are on the main branch, that files are up to date and that there is nothing to commit.  
    
17.  Now you are going to create a new branch to make some changes on git checkout -b mybranch 
    
18.  You should see that you have switched to "mybranch". The checkout -b command creates a branch and then checks out that branch to switch you to it. 
    
19.  Type: `git branch`
     You will see that main branch, as well as mybranch, mybranch should have an asterisk next to is to show that it is the active branch. 
    
20.  Add some text to your README.MD file, just one or two lines 
    
21.  Now you will commit these changes into your new branch 
    
22.  Type: `git status`
     Your changes will show that README.md has been modified, but is not currently staged 
    
23.  Type: `git add README.md` 
    
24.  Type: `git status`
     Your changes are now staged, notice that the file is now showing in green 
    
25. Next up create a commit: `git commit -m "added some lines to readme"`
    If you receive a message asking "Please tell me who you are" run the two commands the message shows to set your name and email address in your local git config. You only ever have to do this once. If you hit that message you will need to rerun the git commit command afterwards. 
    
26.  Those changes are now committed to the new branch. 
    
27.  Now switch back to the main branch `git checkout main` Your changes will disappear, since they were never added to this branch. 
    
28.  Switch back to your new branch `git checkout mybranch` 
    
29.  Notice how when you stitched to main you saw Switched to branch 'main' Your branch is up to date with 'origin/main'. However when you switched back to mybranch you only see Switched to branch 'mybranch' This is because your new branch is only currently a local branch, there is no remote to check against. 
    
30.  Lets fix that by pushing the new branch and its changes up to the remote, being GitLab 
    
31.  Type: git push You will see an error message. Rather helpfully the error message tells you what you SHOULD have typed. git push --set-upstream origin mybranch a shorter version of the same command is git push -u origin mybranch They do exactly the same thing. 
    
32.  Your new branch will now have been pushed to the remote repository  
    
33.  Next lets create a Merge Request in GitLab. Very helpfully the output of the push gives us a link to click to create on. Add a simple description.  
    
34.  Leave everything else as defaults for now (this isn't Merge Request practice), and click Create Merge Request 
    
35.  On the overview screen you should be able to see the commits and changes tabs  If not refresh the page, then they should so 
    
36.  Now click Merge, this will add your changes to the main branch. 
    
37.  Now you can pull these changes down into your local repository 
    
38.  Switch to the main branch git checkout main You will see a message telling you that your branch is behind 'origin/main'. Again, rather helpfully, git tells you the command you probably want to run. 
    
39.  Type: git pull You will get a summary of what has changed, showing a fast-forward, what file has changed and showing any insertions and deletions. 
    
40.  Lastly we are going to tidy up our branch since we no longer need it. 
    
41.  Type: git branch -d mybranch You should see a message telling you that your local branch has been deleted 
    
42.  There is still however one last thing to do, remve the references to the remote branch that also no longer exists thanks to the merge request. This is done with the prune command 
    
43.  Type: git remote prune origin 
    
44.  You've now done once cycle of the most common git commands that you will use day to day.