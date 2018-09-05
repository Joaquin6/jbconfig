<div align="center">
  <a href="https://github.com/Joaquin6">
    <img alt="spaceship →~ prompt" src="https://github.com/Joaquin6/jbconfig/tree/master/zsh/themes/spaceship-zsh/logos/spaceship-theme.png" width="400">
  </a>
</div>

# 🚀⭐ Spaceship ZSH

[![Zsh][zsh-image]][zsh-url]

> A [Zsh][zsh-url] prompt for Astronauts.

Spaceship is a minimalistic, powerful and extremely customizable [Zsh][zsh-url] prompt. It combines everything you may need for convenient work, without unnecessary complications, like a real spaceship.

Currently it shows:

* Clever hostname and username displaying.
* Prompt character turns red if the last command exits with non-zero code.
* Current Git branch and rich repo status:
  * `?` — untracked changes;
  * `+` — uncommitted changes in the index;
  * `!` — unstaged changes;
  * `»` — renamed files;
  * `✘` — deleted files;
  * `$` — stashed changes;
  * `=` — unmerged changes;
  * `⇡` — ahead of remote branch;
  * `⇣` — behind of remote branch;
  * `⇕` — diverged changes.
* Current Mercurial bookmark/branch and rich repo status:
  * `?` — untracked changes;
  * `+` — uncommitted changes in the index;
  * `!` — unstaged changes;
  * `✘` — deleted files;
* Indicator for jobs in the background (`✦`).
* Current Node.js version, through nvm/nodenv/n (`⬢`).
* Current Ruby version, through rvm/rbenv/chruby/asdf (`💎`).
* Current Elixir version, through kiex/exenv/elixir (`💧`).
* Current Swift version, through swiftenv (`🐦`).
* Current Xcode version, through xenv (`🛠`).
* Current Go version (`🐹`).
* Current PHP version (`🐘`).
* Current Rust version (`𝗥`).
* Current version of Haskell GHC Compiler, defined in stack.yaml file (`λ`).
* Current Julia version (`ஃ`).
* Current Docker version and connected machine (`🐳`).
* Current Amazon Web Services (AWS) profile (`☁️`) ([Using named profiles](http://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html)).
* Current Python virtualenv.
* Current Conda virtualenv (`🅒`).
* Current Python pyenv (`🐍`).
* Current .NET SDK version, through dotnet-cli (`.NET`).
* Current Ember.js version, through ember-cli (`🐹`).
* Current Kubectl context (`☸️`).
* Package version, if there's is a package in current directory (`📦`).
* Current battery level and status:
  * `⇡` - charging;
  * `⇣` - discharging;
  * `•` - fully charged.
* Current Vi-mode mode ([with handy aliases for temporarily enabling](./docs/Options.md#vi-mode-vi_mode)).
* Optional exit-code of last command ([how to enable](./docs/Options.md#exit-code-exit_code)).
* Optional time stamps 12/24hr in format ([how to enable](./docs/Options.md#time-time)).
* Execution time of the last command if it exceeds the set threshold.

Want more features? Please, [open an issue](https://github.com/Joaquin6/issues/new) or send pull request.

## Preview

<p align="center">
  <img alt="Spaceship with Hyper and One Dark" src="https://user-images.githubusercontent.com/10276208/36086434-5de52ace-0ff2-11e8-8299-c67f9ab4e9bd.gif" width="980px">
</p>

You can find more examples with different color schemes in [Screenshots](https://github.com/Joaquin6/wiki/Screenshots) wiki-page.

## Requirements

For correct work you will first need:

* [`zsh`](http://www.zsh.org/) (v5.0.6 or recent) must be installed.
* [Powerline Font](https://github.com/powerline/fonts) must be installed and used in your terminal.

## Installing

### [npm]

```
npm install -g spaceship-zsh
```

Done. This command should link `spaceship.zsh` as `prompt_spaceship_setup` to your `$fpath` and set `prompt spaceship` in `.zshrc`. Just reload your terminal.

**💡 Tip:** Update Spaceship to new versions as any other package.

### [oh-my-zsh]

Clone this repo:

```zsh
git clone https://github.com/Joaquin6.git "$ZSH_CUSTOM/themes/spaceship-zsh"
```

Symlink `spaceship.zsh-theme` to your oh-my-zsh custom themes directory:

```zsh
ln -s "$ZSH_CUSTOM/themes/spaceship-zsh/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```

Set `ZSH_THEME="spaceship"` in your `.zshrc`.

### [prezto]

* Follow [prezto-contrib#usage](https://github.com/belak/prezto-contrib#usage) to clone `prezto-contrib` to the proper location.
* Enable the `contrib-prompt` module (before the `prompt` module).
* Set `zstyle ':prezto:module:prompt' theme 'spaceship'` in your `.zpreztorc`.

### [antigen]

Add the following snippet in your `~/.zshrc`:

```
antigen theme https://github.com/Joaquin6 spaceship
```

### [antibody]

Update your `.zshrc` file with the following line:

```
antibody bundle joaquin6/spaceship-zsh
```

### [zgen]

Add the following line to your `~/.zshrc` where you're adding your other Zsh plugins:

```
zgen load joaquin6/spaceship-zsh spaceship
```

### [zplug]

Use this command in your `.zshrc` to load Spaceship as prompt theme:

```
zplug joaquin6/spaceship-zsh, use:spaceship.zsh, from:github, as:theme
```

### Linux package manager

#### Arch Linux

Install the latest master from the AUR package [`spaceship-zsh-git`](https://aur.archlinux.org/packages/spaceship-zsh-git/):

```
git clone https://aur.archlinux.org/spaceship-zsh-git.git
cd spaceship-zsh-git
makepkg -si
```

### Manual

If you have problems with approches above, follow these instructions:

* Clone this repo `git clone https://github.com/Joaquin6.git`
* Symlink `spaceship.zsh` to somewhere in [`$fpath`](http://www.refining-linux.org/archives/46/ZSH-Gem-12-Autoloading-functions/) as `prompt_spaceship_setup`.
* Initialize prompt system and choose `spaceship`.

#### Example

Run `echo $fpath` to see possible location and link `spaceship.zsh` there, like:

```zsh
$ ln -sf "$PWD/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
```

For a user-specific installation, simply add a directory to `$fpath` for that user in `.zshrc`:

```zsh
fpath=( "$HOME/.zfunctions" $fpath )
```

Then install the theme like this:

```zsh
$ ln -sf "$PWD/spaceship.zsh" "$HOME/.zfunctions/prompt_spaceship_setup"
```

For initializing prompt system add this to your `.zshrc`:

```zsh
# .zshrc
autoload -U promptinit; promptinit
prompt spaceship
```

## License

MIT © [Joaquin Briceno](https://github.com/Joaquin6)

[zsh-url]: http://zsh.org/
[zsh-image]: https://img.shields.io/badge/zsh-%3E%3Dv1.0.0.svg?style=flat-square

<!-- References -->

[oh-my-zsh]: http://ohmyz.sh/
[prezto]: https://github.com/sorin-ionescu/prezto
[antigen]: http://antigen.sharats.me/
[zgen]: https://github.com/tarjoilija/zgen
[npm]: https://www.npmjs.com/
[antibody]: https://github.com/getantibody/antibody
[zplug]: https://github.com/zplug/zplug
[n]: https://github.com/tj/n
[xcenv]: http://xcenv.org/
[swiftenv]: https://github.com/kylef/swiftenv
[powerline]: https://github.com/powerline/fonts
