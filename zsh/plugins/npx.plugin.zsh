# NPX Plugin
# https://www.npmjs.com/package/npx

(( $+commands[npx] )) && {
 source <(npx --shell-auto-fallback zsh)
}
