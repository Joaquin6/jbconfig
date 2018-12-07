SHELL=/bin/zsh

LDFLAGS = $(libgl) -lpng -lz -lm

ifeq ($(shell uname -s), Darwin)
  libgl = -framework OpenGL -framework GLUT
else
  libgl = -lGL -lglut
endif

iterm2-shell-integration:
	curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh