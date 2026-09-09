autoload -U compinit
compinit

_comp_options+=(globdots)

export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000 # number of commands kept in memory for the current session
export SAVEHIST=10000 # number of commands saved in the history file

setopt EXTENDED_HISTORY # save timestamp and duration with each entry
setopt SHARE_HISTORY # share history across all active sessions
setopt HIST_IGNORE_SPACE # don't save commands prefixed with a space
setopt HIST_VERIFY # show expanded !! / !42 commands before running them

# in theory, no duplicate commands will be saved or appear in history
setopt HIST_IGNORE_DUPS # don't save a command if it's the same as the previous one
setopt HIST_IGNORE_ALL_DUPS # drop any older duplicate elsewhere in history, keep the newest
setopt HIST_EXPIRE_DUPS_FIRST # drop duplicate commands first (when reaching history's limit)
setopt HIST_SAVE_NO_DUPS # don't write duplicate entries to the history file
setopt HIST_FIND_NO_DUPS # skip duplicates while cycling through history
