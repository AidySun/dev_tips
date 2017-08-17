# GIT
  - checkout one remoted branch to local 
    ```git checkout -b localBranch origin/remoteBranch```
  - push a tag 
    ```git push origin tagName```
  - delete remote branch 
    ```git push origin --delete branchname```

# DOS
  - check user info and group info
    ``` bat
    net localgroup [groupname] 
    net user username 
    ```

  - create directory symbol link 
    ``` bat
    mklink /D [to] [from] 
        /H  creats hard link
        /J  creates a directory junction
    ```
