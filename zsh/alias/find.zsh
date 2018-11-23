#   ---------------------------
#   `find` aliases
#   ---------------------------

# https://alvinalexander.com/unix/edu/examples/find.shtml

# Quickly search for file
alias qfind='find . -name'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# case-insensitive searching
# --------------------------

# find foo, Foo, FOo, FOO, etc.
alias qfind-i='find . -iname'
# same thing, but only dirs
alias fd-i='find . -type d -iname'
# same thing, but only files
alias ff-i='find . -type f -iname'