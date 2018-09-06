# Things I Use: Zsh

While the majority of my shell work these days is done from within emacs using eshell, there are remote servers where its nice to have things setup in a familiar way. There's also always launching emacs. ;)

## Dependencies

I have some dependencies for my config.

```sh
sudo apt-get install aptitude zsh{,-doc} git virtualenvwrapper git-hub
```

* Run `chsh` to set your prompt to `/usr/bin/zsh`.
* Download `hub` at https://github.com/github/hub/releases/latest
* Download dropbox at https://www.dropbox.com/install?os=lnx

There are also some post-install dependencies.

```sh
ghget milkbikis/powerline-shell
python setup.py install

ghget powerline/fonts
./install.sh

ghget denysdovhan/spaceship-prompt
ln -sf "$PWD/spaceship.zsh" "/usr/local/share/zsh/site-functions/prompt_spaceship_setup"
```

## Why I like it

### BETTER COMPLETION

Zsh is basically bash with better completion mechanisms. This isn't to say the method of providing the list of possible completions is any different. I don't actually know much about that, if I'm honest. The reason I like zsh's completion may seem trivial, but when you finish completing something, it doesn't leave little tracks along the way.

In bash, when you tab complete, the possible completions are listed in your terminal and you are provided again with your prompt with your command filled in as you had it. If you hit tab again, you get another screen full of text, and the prompt again. This is fairly spammy and pollutes your scrollback. Zsh on the other hand, will display possible completions below your prompt. When you find one you want, the list just disappears and you have an otherwise clean scrollback.

Like I said, its basically bash, so the small things are the difference.

### OH-MY-ZSH

Another fun thing about zsh is the oh-my-zsh project. Its a framework for zsh configs, including themeing and plugin support. I don't have much experience with the plugin system, which seems like a way to overly organize your customizations (as if this isn't one). The themeing support, though, is top notch. They have support for lots of colors and general nice looks, but also with git support and other things. Very neat.

## How I customize it

This is a mix of my bash configs and my zsh configs. The zsh configs use almost the same syntax as bash. There were a few differences (I think setopt being one of them), but they were minor and quickly fixed with a bit of searching.

### .BASHRC

This is my central `.bashrc`, which loads a few handy libraries, and optionally some machine specific configurations I don't want in source control. As .bashrc is evaluated in interactive shells only, I have it start up a copy of tmux, so I'm never in a situation where I wished I had the session started after I've started some process. I also have it dump a fortune to the screen, which an old unix command for displaying pithy sayings and jokes as the login message.

```sh
  . ~/.shell/aliases
  . ~/.shell/functions
  . ~/.shell/variables
  . ~/.shell/host_specific
  [[ -s "$HOME/.bash_local" ]] && . ~/.bash_local

  if [ -e "`which tmux`" -a "$PS1" != "" -a "$TMUX" == "" -a "${SSH_TTY:-x}" != x ]; then
          sleep 1
          ( (tmux has-session -t remote && tmux attach-session -t remote) || (tmux new-session -s remote) ) && exit 0
          echo "tmux failed to start"
  fi

  # Run on new shell
  if [ `which fortune` ]; then
      echo ""
      fortune
      echo ""
  fi
```

## REFERENCES

* https://justin.abrah.ms/dotfiles/zsh.html
