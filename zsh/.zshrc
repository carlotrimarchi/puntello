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

bindkey -v # use vi-style keybindings for command-line editing
export KEYTIMEOUT=1 # wait 10ms after Esc before acting on it (default 40 == 400ms)

autoload -Uz vcs_info # version control system info
setopt PROMPT_SUBST # allows parameter expansion and command substitution in prompt strings

zstyle ':vcs_info:git:*' formats '%b' # display only branch name from vcs_info

typeset -gA GIT_PROMPT_SYMBOLS=(
    untracked "◇"
    added     "✚"
    modified  "~"
    renamed   "➜"
    deleted   "x"
    conflict  "⚠"
    stash     "\$"
    ahead     "↑"
    behind    "↓"
    diverged  "↕"
)

# Use the symbols above to represent the current git working tree state
# (untracked/added/modified/renamed/deleted/conflicts/stash/ahead/behind)
git_prompt_status() {
    local git_status
    git_status=$(git status --porcelain 2>/dev/null) || return

    local out=""
    # the first 2 columns of `git status --porcelain` output contain the state of:
    # - index/staged (first column)
    # - worktree/unstaged (second column)
    # Cases: ?? (untracked), A (staged), .M|M. (modified unstaged or staged),
    # R (staged rename), .D|D. (deleted unstaged or staged),
    # UU|AA|DD (for unresolved merge conflict: unmerged, added, deleted)
    [[ -n $(grep '^??' <<< "$git_status") ]] && out+="${GIT_PROMPT_SYMBOLS[untracked]} "
    [[ -n $(grep '^A' <<< "$git_status") ]] && out+="${GIT_PROMPT_SYMBOLS[added]} "
    [[ -n $(grep '^.M\|^M.' <<< "$git_status") ]] && out+="${GIT_PROMPT_SYMBOLS[modified]} "
    [[ -n $(grep '^R' <<< "$git_status") ]] && out+="${GIT_PROMPT_SYMBOLS[renamed]} "
    [[ -n $(grep '^.D\|^D.' <<< "$git_status") ]] && out+="${GIT_PROMPT_SYMBOLS[deleted]} "
    [[ -n $(grep '^UU\|^AA\|^DD' <<< "$git_status") ]] && out+="${GIT_PROMPT_SYMBOLS[conflict]} "

    # check for stashed files
    local stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    (( stash_count > 0 )) && out+="${GIT_PROMPT_SYMBOLS[stash]} "

    # check if branch is ahead, behind or diverged
    local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
    if [[ -n $ahead && -n $behind ]]; then
        if (( ahead > 0 && behind > 0 )); then out+="${GIT_PROMPT_SYMBOLS[diverged]} "
        elif (( ahead > 0 )); then out+="${GIT_PROMPT_SYMBOLS[ahead]} "
        elif (( behind > 0 )); then out+="${GIT_PROMPT_SYMBOLS[behind]} "
        fi
    fi

    [[ -n $out ]] && echo "[ ${out}]"
}

precmd_functions+=(vcs_info) # -> $vcs_info_msg_0_ (contains the branch name)

# Left Prompt
# %~ show current directory, with $HOME abbreviated to ~
# %F{N}...%f change foreground color to 256-color code N (here: 198, a pink)
PROMPT=$'%~ %F{198}●%f '

# Right Prompt
RPROMPT=$'${vcs_info_msg_0_} %B$(git_prompt_status)%b'
ZLE_RPROMPT_INDENT=0 # set 0 padding to the right of the right prompt
