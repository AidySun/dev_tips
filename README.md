# TOC
1. [Git](#git)
2. [Windows](#windows)
3. [macOS](#macos)
4. [Markdown](#markdown)
5. [Shell](#shell)
6. [Vim](#vim)
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
  - HTTP github clone on Windows error with message `error setting certificate verify locations`
    ```shell
    git config --system http.sslverify false   # this will switch off the ssl verify for ALL http connections
    ```
  - set upstream to avoid inputing [origin master] for each push
    ```git
    git push --set-upstream origin master
    ```
  - checkout or pull a folder/file instead of the whole repository
    ```
    mkdir myrepo
    cd myrepo
    git init
    git remote add -f origin github/aidysun/repo.git
    git config core.sparseCheckout true
    echo "folder_a/" >> .git/info/sparse-checkout
    git pull
    ```
  - roll back specific file
    ```git checkout <commit> -- path/to/file```

  - rollback a specific history commit
    - `git reset` is used to undo all commits that came afterwards
    - `git revert` undo the effects of only a certain commit
  - show history and diff with file names
    ```
    git log --stat --oneline
    git diff --name-only
    ```
    
  - unstage a file, won't delete from local workspace
    ```
    git reset -- <file>
    ```
    <pre><code>
    # this won't actually unstage a file, it just works for the new files that staged.
    # it stages the removal file from the repo but leaves the file in your working tree
    <del>git rm --cached <file></del></code></pre>
  - rename a tag
    ```
    git tag new_tag old_tag
    git tag -d old_tag
    git push origin :refs/tags/old_tag  # this delete tag remotely, another way is git push --delete origin old_tag
    git push --tags
    # other to get the new tags
    git pull --purne --tags
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


## Shell
  - Turn on ANSI color in Terminal, add following lines in *~/.profile*
    ```
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    ```
  - ``` export PS1="\n\e[32m\w \e[33m\t \e[36m$ \e[0m" ```
  - copy files to local system via SSH
    ```scp -r username@10.1.1.1:~/Downloads/folder ~/Downloads```

  - rename files/folders with regex replacement
    ```
    # rename files contain "2017" to be "2018" 
    for f in *; do echo  mv "$f" "${f/2017/2018}"; done
    # remove echo to do the real renaming
    ```
  - default parameter value
    ```
    set var1 = ${1:-default} # set var1 to be 'default' if $1 is not set
    set var2 = ${VARIABLE2:-empty} # set var2 to be 'empty' if $VARIABLE2 is not set
    ```



## Vim
  - Adjust the splited window size
    ```
    :ctr+w _ " max height
    :ctr+w | " max width
    :ctr+w = " equal size
    ```
  - Open multiple files with splited windows
    ```$ vim -o[O] file1 file2 ...```
  - Scroll screen without changing cursor
    ```
    zz " move current line to middle of screen
    zt " move current line to top of screen
    zb " move current line to bottom of screen
    ```
  - others
    ```
    .        " repeat last action
    :e!      " resotre to doc origin
    I        " insert at first non-space
    A        " insert at end of the line
    :n1,n2 w [filename]    " save lines n1~n2 as 
    ```


