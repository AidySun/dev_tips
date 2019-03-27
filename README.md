# TOC

<!-- MarkdownTOC levels="2" autolink="true" style="ordered" -->

1. [Git](#git)
1. [Windows](#windows)
1. [macOS](#macos)
1. [Markdown](#markdown)
1. [Shell](#shell)
1. [Vim](#vim)
1. [Python](#python)
1. [Chrome](#chrome)
1. [Ubuntu](#ubuntu)
1. [Java](#java)

<!-- /MarkdownTOC -->

------

## Git
  - `bisect` - Use binary search to find the commit that introduced a bug 
    * [Get good with git: `bisect`](https://www.orangejellyfish.com/blog/get-good-with-git-bisect)
  - force overwrite local untracked files
    ```shell
    git fetch --all
    git reset --hard origin/master
    ```
  - merge multiple commits into one
    ```shell
    # approach 1
    git reset --soft HEAD~n
    git commit --amend

    # approach 2
    git rebace --interactive HEAD~n
    # then should pick ealy commit and squash later commit
    ```
  - edit committed message which is NOT pushed yet
    ```shell
    git commit --amend
    ```
  - checkout one remote branch to local 
    ```git checkout -b localBranch origin/remoteBranch```

  - delete remote branch 
    ```git push origin --delete branch_name```

  - stop tracking a file/directory
    ```shell
    git rm [-r] --cached filename/[directory_name]
    or
    git update-index --assume-unchanged filename
    ```

  - HTTP github clone on Windows error with message `error setting certificate verify locations`
    ```shell
    git config --system http.sslverify false   # this will switch off the ssl verify for ALL http connections
    ```

  - checkout or pull a folder/file instead of the whole repository
    ```shell
    mkdir myrepo
    cd myrepo
    git init
    git remote add -f origin github/aidysun/repo.git
    git config core.sparseCheckout true
    echo "folder_a/" >> .git/info/sparse-checkout
    git pull
    ```

  - roll back specific file
    ```shell
    # undeleted files
    git checkout <commit> -- path/to/file

    # file were deleted and committed
    #    1. find the commit deleted the file
    git rev-list -n 1 HEAD -- <deleted_file_path>
    #    2. checkout to the previous commit of commit deleted the file
    git checkout <delete_commit>^ -- <deleted_file_path>

    ```

  - rollback a specific history commit
    - `git revert` undo the effects of only a certain commit
    - `git reset` is used to **undo/delete all commits** that came afterwards
      ```shell
      # rollback to <commit> and force push, ** histories will be deleted in log as well **
      git reset --hard <commit>
      git push origin master --force
      ```

  - show history and diff with file names
    ```
    git log --stat --oneline
    git diff --name-only
    ```
    
  - un-stage a file, won't delete from local workspace
    ```
    git reset -- <file>
    ```
    <pre><code>
    # this won't actually un-stage a file, it just works for the new files that staged.
    # it stages the removal file from the repo but leaves the file in your working tree
    <del>git rm --cached <file></del></code></pre>

  - rename a tag
    ```shell
    git tag new_tag old_tag
    git tag -d old_tag
    git push origin :refs/tags/old_tag  # this delete tag remotely, another way is git push --delete origin old_tag
    git push --tags
    # other to get the new tags
    git pull --purne --tags
    ```
  - merge/checkout files from another branch
    ```shell
    # current branch master
    git checkout another_branch ./file1 ./file2
    ```
  - merge a specific commit
    ```shell
    git cherry-pick <commit_no>
    ```
    
  - [show branch name in bash command prompt](#show_branch_name_in_bash_command_prompt)
  - update [submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to latest 
    ```shell
    git submodule update --init --recursive --remote
    ```
  - [Splitting a subfolder out into a new repository](https://help.github.com/articles/splitting-a-subfolder-out-into-a-new-repository/)    

  - "refusing to merge unrelated histories”
    - `git pull origin master --allow-unrelated-histories`
  - rename file sensitively on Windows
    ```shell
    git mv -f Myfile myfile
    ```


## Windows
  - Disable Hibernate to free up disk space
    - `powercfg -h off`
  - check user info and group info
    ```bat
    net localgroup [groupname] 
    net user username 
    ```

  - create directory symbol link 
    ```bat
    mklink /D [to] [from] 
        /H  creates hard link
        /J  creates a directory junction
    ```
  - run as user
    ```bat
    runas /user:%USERDOMAIN%\%USERNAME% /savedcert "mklink /D C:/folder D:/folder"
    ```
    * _**/savedcert** requires manually password input for the first run, logoff and login to make it work._
  - check architecture(x86 x64) of DLL
    ```bat
    REM run in Visual Studio Command Prompt
    dumpbin /HEADERS <your.dll> | more
    ```
  - Windows equivalent of `wc -l` in Batch, `find /c /v ""`
    ```bat
    keytool -list | find /c /v ""
    ```
  - run cmd from a specific folder in a new window
    ```bat
    start /D C:\Users cmd /k echo "Hello world."
    ```

## macOS
  - lockscreen using command
    ```shell
    /System/Library/CoreServices//Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
    ```
  - show/hide hidden files and directories in Finder
    ```shell
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
    ```
  - find by name and execute command to results
    ```shell
    find . -iname 'xc*data' -exec git rm -r --cached {} \;
    ```
    
  - list exported symbols of shared library
    ```shell
    nm -a log4cplus
    ```
  - Show build settings of Xcode projects
    ```shell
    xcodebuild -project myProj.xcodeproj -target "Release_Cocoa64" -showBuildSettings
    ```
  - Quick Look or Preview text files in Finder
    ```shell
    # e.g. xml files
    sudo  find . -name *.xml -exec SetFile -t TEXT {} ; 
    # alternative https://github.com/sindresorhus/quick-look-plugins?? not tried 
    ```
  - Cannot find dylib files when adding links in Xcode?
    - [Using Other Linker Flags instead of selecting](https://stackoverflow.com/questions/32576979/libiconv-dylib-not-found-in-xcode-7-gm), e.g. `-liconv` instead of `libiconv.dylib`
    - As well as system frameworks (e.g. `-framework IOKit`)
  - hostname
    ```shell
    scutil --get LocalHostName
    sudo scutil --set HostName new.host.name
    hostname
    ```
    
  - enable built-in VNC control of macOS Mojave (10.14) when remoting desktop using VNC client
    1. Open `System Preferences -> Security & Privacy -> Privacy -> Accessibility`
    1. In `Finder`, navigate to `/System/Library/CoreServices/RemoteManagement/AppleVNCServer.bundle/Contents/MacOS/AppleVNCServer`
    1. Add `AppleVNCServer` to granted list.

## Markdown
- adding TOC in markdown
  [](https://github.com/naokazuterada/MarkdownTOC)

- bookmark
  ```
  <a name="link_name">content to show</a>
  ...
  [reference](#link_name)
  ``` 
- [Paste to Markdown](http://euangoddard.github.io/clipboard2markdown/)


## Shell
  - capture command output to file while alos viewing it live [more](https://askubuntu.com/a/731237)
    ```shell
    command |& tee file.txt
    ```
  - Turn on ANSI color in Terminal, add following lines in *~/.profile*
    ```shell
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    ```
  - <a name="show_branch_name_in_bash_command_prompt">show branch name in bash command prompt </a>
    ```shell
    function git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }

    export PS1="\n\[\e[1;33m\]\t \[\e[1;32m\]\w\[\e[0;33m\] $(git_branch) \n\[\e[1m\]\[\e[0;32m\]>>> \$ \[\e[0m\]"
    ```

  - copy files to local system via SSH
    ```scp -r username@10.1.1.1:~/Downloads/folder ~/Downloads```

  - rename files/folders with regex replacement
    ```shell
    # rename files contain "2017" to be "2018" 
    for f in *; do echo  mv "$f" "${f/2017/2018}"; done
    # remove echo to do the real renaming
    ```
  - default parameter value
    ```shell
    set var1 = ${1:-default} # set var1 to be 'default' if $1 is not set
    set var2 = ${VARIABLE2:-empty} # set var2 to be 'empty' if $VARIABLE2 is not set
    ```

  - prompt for user input
    ```shell
    read -p "input a word: " inputtedVar
    echo $inputtedVar
    ```

  - auto input for prompt/password
    ```shell
    expect <<- DONE
    spawn scp $1 user@192.168.1.1:/work/
    expect "password:"
    send -- "mypassword\r"
    #interactive
    expect eof
    DONE
    ```



## Vim
  - Key mappings
    ```
    // imap: insert mode, <c-d>:ctr+d, <esc>ddi: key in order 
    :map - x
    :imap <c-d> <esc>ddi
    :let mapleader = "-"
    :vmap <leader>\ U
    // no remap
    :inoremap <c-d>
    // unmap
    :nunmap -
    ```
  - Adjust the split window size
    ```
    :ctr+w _ " max height
    :ctr+w | " max width
    :ctr+w = " equal size
    ```
  - Open multiple files with split windows
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
    :e!      " restore to doc origin
    I        " insert at first non-space
    A        " insert at end of the line
    :n1,n2 w [filename]    " save lines n1~n2 as 
    ```

## Python
  - Install packages in Jupyter Notebook
    ```
    import sys
    !conda install pip
    !python -m pip install keras
    ```
  - Location of installed package: 
    `pip show <package_name>`
  - Installed packages: 
    `pip list`

  - platform
    ```
    import platform
    print(platfrom.platform())
    print(platfrom.python_version())
    ```

## Chrome
  - Download CRX extension
    - https://clients2.google.com/service/update2/crx?response=redirect&prodversion=[PRODVERSION]&x=id%3D[EXTENSIONID]%26uc
      - [PRODVERSION] is the version of Chrome, which must be 31.0.1609.0 at the very least
      - [EXTENSIONID] is the ID of the extension

## Ubuntu
  - List installed packages
    ```
    apt list --installed
    dpkg --get-selections
    ```
    
## Java
  - JVM status check
    ```
    jps -v
    jstat -gc <jvmid>
    jmap -heap <jvmid>
    jmap -histo:live <jvmid> | more
    ```
  - Eclipse cannot connect to Marketplace (from China)
    * add following content to `eclipse.ini` (in Eclipse.app on macOS)
      ```tex
       -Djava.net.preferIPv4Stack=true 
      ```

