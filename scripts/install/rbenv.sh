#!/bin/bash

# https://github.com/rbenv/rbenv#readme
# For a more automated install, you can use rbenv-installer. If you prefer a manual approach, follow the steps below.
# https://github.com/rbenv/rbenv-installer#rbenv-installer
# This will get you going with the latest version of rbenv without needing a systemwide install.



#####################################################
########### 1. Clone rbenv into ~/.rbenv. ###########
#####################################################

git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# Optionally, try to compile dynamic bash extension to speed up rbenv. Don't worry if it fails; rbenv will still work normally:

pushd ~/.rbenv; src/configure && make -C src; popd

#######################################################################################################
########### 2. Add ~/.rbenv/bin to your $PATH for access to the rbenv command-line utility. ###########
#######################################################################################################
# For bash:

# $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
# For Ubuntu Desktop:

# $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
# For Zsh:

# $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
# For Fish shell:

# $ set -Ux fish_user_paths $HOME/.rbenv/bin $fish_user_paths

######################################################
########### 3. Set up rbenv in your shell. ###########
######################################################

~/.rbenv/bin/rbenv init

# Follow the printed instructions to set up rbenv shell integration.
# https://github.com/rbenv/rbenv#how-rbenv-hooks-into-your-shell

############################################################################################################
# 4. Restart your shell so that PATH changes take effect. (Opening a new terminal tab will usually do it.) #
############################################################################################################

#################################################################################
#### 5. Verify that rbenv is properly set up using this rbenv-doctor script: ####
#################################################################################

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

###########################################################################################################################################
# 6. (Optional) Install ruby-build, which provides the rbenv install command that simplifies the process of installing new Ruby versions. #
# https://github.com/rbenv/ruby-build#readme
# https://github.com/rbenv/rbenv#installing-ruby-versions
###########################################################################################################################################
