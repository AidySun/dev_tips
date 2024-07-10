# TOC

1. [Git](#git)
   1. [show size info of a history file](#show-size-info-of-a-history-file)
   2. [checkout/reset/revert/clean](#checkoutresetrevertclean)
   3. [Merge / Conflict](#merge--conflict)
   4. [stash](#stash)
   5. [branch](#branch)
   6. [submodule](#submodule)
   7. [.git](#git-1)
   8. [git log](#git-log)
   9. [tilde(~) caret(^) at-sign(@)](#tilde-caret-at-sign)
   10. [stash file to patches](#stash-file-to-patches)
2. [Windows](#windows)
3. [macOS](#macos)
4. [Markdown](#markdown)
5. [Shell](#shell)
6. [Vim](#vim)
   1. [tabs](#tabs)
7. [Python](#python)
8. [Chrome](#chrome)
9. [Ubuntu](#ubuntu)
10. [CentOS](#centos)
11. [Java](#java)
12. [CPP](#cpp)
13. [XPath](#xpath)
14. [VMWare](#vmware)
15. [JIRA](#jira)
16. [UML](#uml)
       1. [Class relationship](#class-relationship)
       2. [Composition v.s. Aggregation](#composition-vs-aggregation)
17. [Regexp](#regexp)
    1. [online tool](#online-tool)
18. [Opensource](#opensource)
19. [Tools](#tools)
    1. [vscode](#vscode)
       1. [search multiple line](#search-multiple-line)

------

## Git

### show size info of a history file
There is a file A, I want to check its size in version HEAD~2:

```bash
>>> $ git ls-tree -rl HEAD~2 A
100644 blob f787098xxxxx 1231 A
```

`100644` is the file size of `A` with version `HEAD~2`. To make the size info readable for human:

```bash
>>> $ git ls-tree -rl HEAD~2  A | awk '{ size = $4; units = "B"; if (size > 1024) { size /= 1024; units = "KB"; if (size > 1024) { size /= 1024; units = "MB"; if (size > 1024) { size /= 1024; units = "GB"; } } } printf "%s %s\n", size, units; }'

1.5571 MB
```

### checkout/reset/revert/clean

- recover/undo previous `git reset --hard`
  - use `git reflog` to show history
  - use `git reset --hard <hash>` to recover the old files
  
- If you want to revert changes made to your working copy, do this:
  ` git checkout . `

- If you want to revert changes made to the index (i.e., that you have added), do this. 
  - **Warning this will reset all of your unpushed commits to master!:**
  ` git reset `

- reset --soft a specified file with path
  `git reset <commitid> -- path/to/file`
- If you want to revert a change that you have committed, do this: (it will generate a new revert commit in git log)
  ` git revert <commit 1> <commit 2> `

- If you want to remove untracked files (e.g., new files, generated files):
  ` git clean -f `

- Or untracked directories (e.g., new or automatically generated directories):
  ` git clean -fd `

- checkout remote branch to local with diff name
  ` git checkout -b <local_branch_name> <remote_name>/<remote_branch_name>`

### Merge / Conflict

- fix conflict by accepting others/ours
```
git checkout --theirs <conflicted_file>
git checkout --ours <conflicted_file>
```

### stash 

- stash specific files
  - `git stash -- <file>`
- speed up clone: `git clone https://github.com.cnpmjs.org/xxxxx/xxxxxxx.git`
- Fatal: Refusing to merge unrelated histories
  New repo was created via UI with init commit. 
  At the same time, git add at local and with another init commit. 
  When git pull at local, git treats those two as diff trees since they don't have same origin.
  Solution 1: using `git clone` to clone repo to local
  Solution 2: `git pull origin [repo] --allow-unrelated-histories`
- force pull a repo to overwrite local changes
  ```
  git fetch --all
  git reset --hard origin/master
  git pull --force # not work if repo has forced push
  ```
- `bisect` - Use binary search to find the commit that introduced a bug 
  * [Get good with git: `bisect`](https://www.orangejellyfish.com/blog/get-good-with-git-bisect)
- force overwrite local untracked files
  ```shell
  git fetch --all
  git reset --hard origin/master
  ```
- change message of last commit
  ```
  git commit --amend
  ```
- merge multiple commits into one
  ```shell
  # approach 1
  git reset --soft HEAD~n
  git commit --amend
  # approach 2
  git rebase --interactive HEAD~n
  # or
  git rebase -i <commit#>
  # then should pick ealy commit and squash later commit
  git rebase --continue
  # push to remote repository forcely
  git push origin <branch> --force
  ```
- [edit a pushed commit message](https://stackoverflow.com/questions/1186535/how-to-modify-a-specified-commit)
  ```
  git rebase -i '<commitno>^'
  # change pick to be edit, save
  git commit --amend
  git rebase --continue
  git push --force
  ```
- edit last committed message 
  ```shell
  git commit --amend
  git push --force    # if pushed already
  ```
- stop tracking a file/directory
  ```shell
  git rm [-r] --cached filename/[directory_name] # --cached will keep the removed file locally
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
  git log -- <deleted_file_path>
  git checkout <delete_commit>^ -- <deleted_file_path> 
  #or
  git checkout <before_delete_commit> -- <deleted_file_path> 
  ```
- rollback a specific history commit
  - `git revert` undo the effects of only a certain commit
  - `git reset` is used to **undo/delete all commits** that came afterwards
    ```shell
    # rollback to <commit> and force push, ** histories will be deleted in log as well **
    git reset --hard <commit>
    git push origin master --force
    ```
  - For local changes, rollbace/rebase one commit
  - `git rebase -i xxxxx^`
- show history and diff with file names
  ```
  git log --stat --oneline
  git diff --name-only
  git log -- file.ext     # by file
  git log -p              # print patch, source diff 
  git show <commit_no>    # show specific comment
  git log --grep="smth"   # filter by message
  git shortlog            # group my author
  ```
  
- un-stage a file, won't delete from local workspace
  ```
  git reset -- <file>
  ```
  <pre><code>
  this won't actually un-stage a file, it just works for the new files that staged.
  it stages the removal file from the repo but leaves the file in your working tree
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
- merge a specific commit
  ```shell
  git cherry-pick <commit_no>
  ```
- [Splitting a subfolder out into a new repository](https://help.github.com/articles/plitting-a-subfolder-out-into-a-new-repository/)    
- "refusing to merge unrelated histories”
  - `git pull origin master --allow-unrelated-histories`
- rename file sensitively on Windows
  ```shell
  git mv -f Myfile myfile
  ```
- Commit statistics : `git shortlog -sn`

### branch

- show all branches
  ```
  git branch -a  # -r
  git branch -vv
  git remote show origin
  git ls-remote --heads origin
  ```
- merge/checkout files from another branch
  ```shell
  # current branch master
  git checkout another_branch ./file1 ./file2
  ```
- [show branch name in bash command prompt](#show_branch_name_in_bash_command_prompt)

- checkout one remote branch to local 
  ```
  git checkout --track origin/branch
  # --track is shorthand for -b [local_branch] [remote]/[branch]
  ```
  or
  ```
  git fetch origin anotherBranch:localBranch
  git branch
  git checkout localBranch
  ```
- delete remote branch 
  ```
  git push origin --delete branch_name
  ```
- force push to remote repository
  ```
  git push origin <branch> --force
  ```

### submodule

- add - **NOTE:** `.gitmodules` should be committed for tracking
  ```
  git submodule add http....
  ```
- clone / update submodules
  - when clone
  ```
  git clone --recurse-submodules https://main-repo
  ```
  - after clone (if `--recurse-submodules` was forgotten)
  ```
  git submodule update --init    # which is a combination of following two steps
  git submodule init
  git submodule update
  ```

- show submodules status
  ```
  git config status.submodulesummary 1
  ```

- update [submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to latest 
  ```shell
  git submodule update --init --recursive --remote [subModuleName]
  git submodule update --remote     # would update existing submodule to latest
  ```

- [how to remove a submodule](https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule)
  ```
  0. mv a/submodule a/submodule_tmp
  1. git submodule deinit -f -- a/submodule    
  2. rm -rf .git/modules/a/submodule
  3. git rm -f a/submodule
  ```

- Reinit all local submodules / cleanup messed submodules
  1. remove all submodules in `.git/config`
  2. empty folder `.git/modules/*`
  3. empty real path of submodules (may refer to the pathes in `.gitmodules`) 
  4. `git submodule update --init --recursive`

### .git

- shrink huge `.git/objects`
  ```
  git fsck 
  git prune
  ```

### git log

- show diff between branches, show differences in `branch2` comparing to `branch1`
  ```
  git log --cherry branch1..branch2
  ```

### tilde(~) caret(^) at-sign(@)

- tl;tr;
  - `~` : goback on a straight line, one current main branch
  - `^` : used on merge commit, HEAD^1 is main branch merged into, HEAD^2 is the side branch merged into main branch.
  - `@` : used for the `git reflog`
- https://www.golinuxcloud.com/git-head-caret-vs-tilde-at-sign-examples/#:~:text=The%20tilde%20%28~%29%2C%20caret%20%28%5E%29%20and%20at-sign%20%28%40%29,refer%20to%20the%20parent%20of%20that%20particular%20commit.

### stash file to patches

```shell
git stash list | while read stash; do
    index=$(echo "$stash" | cut -d: -f1 |cut -d'}' -f1 | cut -d'{' -f2)
    echo $index
    git stash show -p "$index" > "stash_$index.patch"
done
# in target repo:
# git apply xxx.patch
```

## Windows

- search files by size in Explorer with keywords like `* size:>50MB<100MB`

- Hide cmd window after launching an exe file in a bat/cmd file. Using `start` command.
  ```
  @echo off
  start aaa.exe
  ```
- Outlook rules of same email address with different names
  - https://www.msoutlook.info/question/sender-name-contains-specific-text-rule
- Manage stored certificates 
  - Win+R `control keymgr.dll`
  - Control Panel\All Control Panel Items\Credential Manager
- turn off terminal bell in subsystem linux
  ```
  $ sudo vi /etc/inputrc
  set bell-style none
  ``` 
- Screenshot of current window
   ```
   Win + Alt + PrtSc
   ```
- Path of saved screenshot token with "Win+Shift+S"
  ```
  C:\Users\<username>\AppData\Local\Packages\Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy\TempState\ScreenClip
  ```
- Path of root of WSL Ubuntu from Store
  ```
  C:\Users\<username>\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState
  ```
- copy multiple files between folders
  ```
  robocopy \src\dir  \dest\dir  file1.txt file2.pdf
  ```
- task management in cmd
  ```
  tasklist /FI "IMAGENAME eq xxx.exe"
  taskkill /IM "xxx.exe" /F
  ```
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
- determine .lib is static or dynamic
  ```bat
  REM run in Visual Studio Command Prompt
  lib /list xxx.lib     # xxx.dll - dynamic,   xxx.obj - static
  ```
- Windows equivalent of `wc -l` in Batch, `find /c /v ""`
  ```bat
  keytool -list | find /c /v ""
  ```
- run cmd from a specific folder in a new window
  ```bat
  start /D C:\Users cmd /k echo "Hello world."
  ```
- [Add "Open with Sublime Text 3" to Windows Explorer Context Menu](https://gist.github.com/AidySun/7e387fc6a8f5d70d34c258c3a0595bc9)
- Visual Studio cleans wrong output directory when clean/rebuild?
  - Intermediate Directory - if two platforms share the same intermediate dir, this issue will happen ever they have diff output dir.
- Unallocated space in USB flash drive, run `diskpart`
  ```
  disk list
  select disk 1
  clean
  clean partition primary
  ```

## macOS

- monitor a program by its name: [monitor.sh](monitor.sh)

- Use old build system with Xcode 10 and later : `xcodebuild  -UseModernBuildSystem=NO -project xxx`

- Remove download from info:
  ```
  xattr -r -d com.apple.metadata:kMDItemWhereFroms xxx.zip
  xattr -r -d com.apple.quarantine xxx.zip
  ```
- Sort child folders by size
  ```
  du -hc -d 1 | grep -v "/$" | sort -rh
  ```
- *"Your password does not meet the requirements"*, reset the password policy database:
  ```
  sudo pwpolicy -clearaccountpolicies
  ```
- Storage management
  - `~/Library/Caches`
  
- if usb of MBR cannot charing iPhone
  ```
  sudo killall -STOP -c usbd
  sudo killall -CONT usbd
  ```
- add user to group
  ```shell
  sudo dseditgroup -o edit -a aidy -t user wheelGroup
  ```
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
  # exec two grep commands, the 2nd one is based on 1st one's result
  find . -iname "*.ts"  -exec sh -c "grep  -H 'dt.an.13.030' -A 2 {} | grep -H '<translation>' " \;
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

- change default location to store screenshots
  ```shell
  defaults write com.apple.screencapture location ~/Pictures/screenshots/
  ```
- mount writable NTFS hard disk
  ```shell
  0. plug NTFS usb
  1. sudo nano /etc/fstab
  2. LABEL=NAME none ntfs rw,auto,nobrowse
  3. Ctrl+O
  4. remove NTFS usb and reconnect it
  5. ls /Volumes
  ```
- [Accessing Grayed-out Preference Panes](http://walkingtowel.org/2010/02/25/accessing-mac-os-x-leopard-greyed-out-preference-panes/)
  - Duplicate `System Preferences.app`, and delete `NSPrefPaneGroups.xml`.

- Useful commands from linux
  - `ulimit -a, at, cron `

## Markdown

- how to add page break in Markdown
  ```markdown
  <div style="page-break-after: always"></div>
  ```

- bookmark
  ```markdown
  <a name="link_name">content to show</a>
  ...
  [reference](#link_name)
  ```
- [Paste to Markdown](http://euangoddard.github.io/clipboard2markdown/)

## Shell

- replace text content recursively
  ```
  find . -type f -name "config" -exec sed -i 's/aaa/bbb/g' {} \;
  ```
- sort file by size: `du -h -d 1 | sort -h -r `

- rename files/directories by regexp with find command (checked on Ubuntu)
  ```
  find . -type f -name "*OldFileName*" -exec rename -v 's/OldFile/new_file/' {} \;
  ```
- diff
  - diff a.txt b.txt    # normal diff
    - `3c3`: 3-line num, c-change (d-delete, a-addition), 3-line number
    - `<`: delete, `>`: add
  - diff -c a.txt b.txt # context diff
  - diff -u a.txt b.txt # unified diff
- margin setting for Ubuntu terminal : https://askubuntu.com/questions/115762/increase-padding-in-gnome-terminal
- compare folders
  ```
  diff -rq folder1 folder2
  ```
- rename files/folders with regex replacement
  ```shell
  # rename files contain "2017" to be "2018" 
  for f in *; do echo  mv "$f" "${f/2017/2018}"; done
  ```

- screen - multiple session in one terminal, especially useful for linux terminal
  ```
  screen -ls
  screen -r xx # restore/reattach
  C-a w   / C-a "  # list all
  C-a n     # next
  C-a C-a
  C-a 0..9
  C-a '
  C-a k    # close current window in screen
  ```
  - `.screenrc`
    ```
    vbell on
    vbell_msg ''   # turn off wuff----wuff----!
    termcapinfo * vb=:   # set flash to a empty string
    ```
    - reload `screenrc` without restarting screen : `Ctrl+a : source /etc/screenrc`
- why prefer `$()` to `` ` ` ``
  * because `$()` can be nested
  * it doesn't need to escape
- prefer `[[]]` to `[]`
  ```
  [ "${name}" \> "a" -o "${age}" \< "20"]   # using []
  [[ "${name}" > "a" && "${age}" < "20"]]   # using [[]]
  ```
- bash options
  ```
  #!/bin/bash
  set -o nounset
  set -o errexit
  ...
  ```
- redirection in shell
  - 0: stdin, 1: stdout, 2: stderr
    ```
    ls a.txt b.txt > output.txt 2> error_output.txt
    ls a b c > all_output.txt 2>&1
    ```
    - `>&` redirects one out data stream to another
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
  ```
  scp -r username@10.1.1.1:~/Downloads/folder ~/Downloads
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
- `xargs` - each line as a parameter to a cmd
  ```
  cat file.txt | xargs -L1 <cmd>
  ```
- [replacing all line breaks](https://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed)
  ```
  sed ":a;N;$!ba;s/\n/,/g' file
  ```

## Vim

- insert continus index to starting of lines
  ```
  :%s/^/\=line('.').'.'
  ```
  - add 1, 2, 3, from line 10 to line 88 : `10,88s/^/\=line('.')-9.'.'`

- case [in-]sensitive search with `\c`: E.g. `/InSensitive\c`
 
- Hide vim to background
  ```
  # in vim
  Ctrl+z
  # then, return to vim
  fg
  ```
- vim color scheme
  ```
  # color themes locate in /usr/shared/vim/vim80/colors/
  # in ~/.vimrc
  colorscheme industry
  ```
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
  ```
  $ vim -o[O] file1 file2 ...
  ```
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
- Plugin
  - https://github.com/junegunn/vim-plug/wiki/tutorial
  - https://github.com/peterhoeg/vim-qml

### tabs

- open multiple files in diff tabs: vi -p f1.txt f2.txt
- navigation between tabs:
  - command mode:
    ```
    :tabn # go to next tab
    :tabp # go to previous tab
    :tabnew # create a new tab
    :tabclose # close a new tab
    :tabclose {i} # close the tab in postion {i}
    :tabe {file} # edit in new tab
    :tabfirst # go to first
    :tabm 0  # move to first
    ```
  - normal mode:
    ```
    gt    # go to next tab
    gT    # go to previous tab
    {i}gt # go to tab in position i
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
  - https://clients2.google.com/service/update2/crx?response=redirect&prodversion=[PRODVERSION]&acceptformat=crx2,crx3&x=id%3D[EXTENSIONID]%26uc
    - [PRODVERSION] is the version of Chrome, which must be 31.0.1609.0 at the very least
    - [EXTENSIONID] is the ID of the extension

## Ubuntu

- force to relaod `~/.tmux.conf`
  ```
  # in tmux
  tmux kill-server
  ```
- List installed packages
  ```
  apt list --installed
  dpkg --get-selections
  ```
- show hidden folders `Ctrl+H` - tried on CentOS

- what if python was removed from system
  - `Ctrl+Alt+F4` to enter terminal
  - `sudo apt-get install ubuntu-minimal ubuntu-standard ubuntu-desktop`
  - `sudo reboot`
  - `startx`

- `pip` does not work [after upgrade](https://stackoverflow.com/questions/49836676/error-after-upgrading-pip-cannot-import-name-main), it says `ImportError: cannot import name 'main'`
  ```
  sudo python[3] -m pip uninstall pip && sudo apt install python3-pip --reinstall
  pip3 # or
  python3 -m pip
  ```

## CentOS

- how to change `libc.so.6` link? **Do not try to rm it and recreate the link**
  ```
  ldconfig -l -v /lib64/libc-2.30.so
  ```

## Java

- JVM status check
  ```
  jps -v
  jstat -gc <jvmid>
  jmap -heap <jvmid>
  jmap -histo:live <jvmid> | more
  ```
- Get JNI method signature from java class
  ```
  javap -s a.class
  ```
- Eclipse cannot connect to Marketplace (from China)
  * add following content to `eclipse.ini` (in Eclipse.app on macOS)
    ```tex
     -Djava.net.preferIPv4Stack=true 
    ```
- Chrome Selenium WebDriver cannot perform another action before previous action finishes
  - tried `executeAsyncScript`, `sendKeys`, `click()` and Selenium IDE recording, no one worked
  - final solution was to use `onclick` function of web element
- Reset Eclipse Color and Fonts to Default
  ```
  rm <workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings
  ```

## CPP

- Since C++11, `unique_ptr` supports dynamic array, but not `shared_ptr`
  ```
  std::unique_ptr<int[]> p(new int[nsize]); // type is int[]
  ```

## XPath

- Samples
  - //table[class='table-class']//td[contains(text(),'row1']/following-sibling::td[text()='column 2']
  - //div[@alt='This is a img' and @class='img-class']

## VMWare

- Shortcut to escape VM (on Windows): `Ctrl+Alt`
  - Switch back to vmware with `Alt+Tab` then `Ctrl+g`

## JIRA

- search multiple version with wildcard `*`: `versionMatches("v1.*")`
  - `issuetype = Bug AND affectedVersion  IN versionMatches("5.15.*")  AND text ~ "binding broken"`

## UML

#### Class relationship

1. extension : `<|--`
1. composition : `*--`
1. aggregration : `o--`
 
#### Composition v.s. Aggregation

- Composition
  - Composite aggregation is a subtype of aggregation relation with characteristics as:
    - It is a two-way association between the objects.
    - It is a whole/part relationship.
    - If a composite is deleted, all other parts associated with it are deleted.
  - The folder could contain many files, while each File has exactly one Folder parent. If a folder is deleted, all contained files are removed as well.
  - `Folder "1" *-- "many" File` 
- Aggregation
  - Let us consider an example of a car and a wheel.
  - A car needs a wheel to function correctly, but a wheel doesn't always need a car. It can also be used with the bike, bicycle, or any other vehicles but not a particular car. Here, the wheel object is meaningful even without the car object. Such type of relationship is called UML Aggregation relation.
  - `Car "1" o-- "many" Wheel : aggregation` 


## Regexp


- search words **not included**: `(?!notincludeword)`, `(?!word\b)`

- search two words accross multiple lines: `(?:\n.*?){0,2}`
  - `(?:\n.*?)` match anything including line break
  - `{0,2}` match times range
  - e.g. search for `class....data` at most 22 lines
  ```
  (class.\{)(?:\n.*?){1,22}data
  ```

### online tool
- https://regex101.com/r/BGXRP7/1
- https://regexr.com/


## Opensource

- How to design a version-compatible library
  - https://ometer.com/parallel.html


## Tools

### vscode

#### search multiple line

- serach content matchs "Button" & "background" appears within 10 lines
`Button.*(?:\n.*(?:\n.*)){0,10}.*background`
