# JBConfig

----------------------------------------------------------------------------------------------------

## Prerequisites

### Homebrew, iTerm2 and Zsh

* If you haven’t already, install the mac package manager [Homebrew](https://docs.brew.sh/Installation.html).
* Install the terminal [iTerm2](https://www.iterm2.com/downloads.html) here or through homebrew using `brew cask install iterm2`
* Then install the shell [Zsh](http://www.zsh.org/) (a alternative to [bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29)) using `brew install zsh`
* Open iTerm2. To change the default shell to Zsh rather than bash, run the change shell command in your terminal. `chsh -s /bin/zsh`

The Zsh resource file, `~/.zshrc`, is a script that is run whenever you start Zsh.

### [SymbolicLinker](./docs/SYMBOLICLINKER.md)

### [Syncing Settings](https://packagecontrol.io/docs/syncing)

#### From Mac to Windows

```sh
cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
mkdir -p ~/Dropbox/Sublime
ln -s ~/Dropbox/Sublime/User
ln -s ~/Dropbox/Sublime/sublime
```

```bash
cd "$env:appdata\Sublime Text 3\Packages\"
rmdir -recurse User
cmd /c mklink /D User $env:userprofile\Dropbox\Sublime\User
cmd /c mklink /D sublime $env:userprofile\Dropbox\Sublime\sublime
```

## References

* <https://github.com/Homebrew/homebrew-bundle>
