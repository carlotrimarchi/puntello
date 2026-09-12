# Keep $path/$PATH free of duplicates
# Several tools (vite, vite+, pyenv, rye, this file, .zshrc)
# prepend their own bin dir on every shell startup. This creates
# unnecessary duplications, which might bloat $PATH and slow down every
# command lookup for the rest of the session.
# Must be set before anything else touches $PATH.
typeset -U path PATH

export XDG_CONFIG_HOME="$HOME/.config" # set base config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh" # set zsh config directory
