# The only host specific configuration I have is to make my prompt super simple in the case where
# I'm using eterm (emacs terminal). This is mainly due to the fact that my emacs buffers tend to be
# rather narrow and having a large, information filled prompt makes actually using the terminal more difficult.

if [ $TERM = "eterm-color" ]; then
  # prompt for emacs (width sensitive)
  PS1='\u@\h:\w\$ '
fi

# I also need to source the virtualenvwrapper stuff from ubuntu's installation location, so do that if we're on linux.
if [ `uname` = "Linux" ]; then
   # assuming ubuntu
   . $USER_SHARE/virtualenvwrapper/virtualenvwrapper.sh
fi
