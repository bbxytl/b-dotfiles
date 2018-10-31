[user]
  name = bbxytl
  email = bbxytl@gmail.com

[core]
  autocrlf = false
  whitespace = fix,space-before-tab,tab-in-indent,trailing-space
  excludesfile = ~/.gitignore

[alias]
  st = status
  ci = commit
  br = branch -vv
  co = checkout
  lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
  cp = cherry-pick

[color]
  ui = true

[push]
  default = current

[git-up "bundler"]
  check = false
  autoinstall = true

[git-up "fetch"]
  all = true

[git-up "rebase"]
  arguments = --preserve-merges
  st = status -sb
  ci = commit
  br = branch -vv
  co = checkout
  lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
  cp = cherry-pick

[rerere]
  enabled = true

[url "git@github.com:"]
  pushInsteadOf = "git://github.com/"
  pushInsteadOf = "https://github.com/"
[http]
	postBuffer = 524288000

# Kaleidoscope.app as difftool and mergetool.
[diff]
    tool = Kaleidoscope
[difftool "Kaleidoscope"]
  cmd = ksdiff --partial-changeset --relative-path \"$MERGED\" -- \"$LOCAL\" \"$REMOTE\"
[merge]
    tool = Kaleidoscope
[mergetool "Kaleidoscope"]
  cmd = ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot
  trustExitCode = true
