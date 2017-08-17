# GIT
  - checkout one remoted branch to local 
    ```git checkout -b localBranch origin/remoteBranch```
  - push a tag 
    ```git push origin tagName```
  - delete remote branch 
    ```git push origin --delete branchname```

# DOS
  - check user info and group info
    ``` 
    net localgroup [groupname] 
    net user username 
    ```

  - create directory symbol link 
    ``` 
    mklink /D [to] [from] 
        /H *creats hard link*
        /J *creates a directory junction*
    ```
