# TOC
1. [Git](#git)
2. [Windows](#windows)
3. [macOS](#macos)
4. [Markdown](#markdown)
------

## Git
  - checkout one remoted branch to local 
    ```git checkout -b localBranch origin/remoteBranch```
  - push a tag 
    ```git push origin tagName```
  - delete remote branch 
    ```git push origin --delete branchname```
  - stop tracking a file/directory
    ```shell
    git rm [-r] --cached filename/[directoryname]
    or
    git update-index --assume-unchanged filename
    ```
  - HTTP github clone on Windows error with message ```error setting certificate verify locations```
    ```shell
    git config --system http.sslverify false   # this will switch off the ssl verify for ALL http connections
    ```
  - set upstream to avoid inputing [origin master] for each push
    ```git
    git push --set-upstream origin master
    ```


## Windows
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
  - run as user
    ```bat
    runas /user:%USERDOMAIN%\%USERNAME% /savedcert "mklink /D C:/folder D:/folder"
    ```
    * _**/savedcert** requires manually password input for the first run, logoff and login to make it work._


## macOS
  - show/hide hidden files and directories in Finder
    ```shell
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
    ```
  - find by name and execute command to results
    ```shell
    find . -iname 'xc*data' -exec git rm -r --cached {} \;
    ```
    
    
## Markdown
  - adding TOC in markdown
    ```markdown
    # TOC
    1. [Git](#git)
    2. [Windows](#windows)
    3. [macOS](#macos)
    
    ## Git
    ## Windows
    ## macOS
    ```
