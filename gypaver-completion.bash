# see https://groups.google.com/forum/#!topic/paver/Ba5YNXNhs9U

_gypaver()
{
    local cur
    COMPREPLY=()
    # Variable to hold the current word
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Build a list of the available tasks from: `gypaver --help --quiet`
    local cmds=$(gypaver -hq | awk '/^  ([a-zA-Z][a-zA-Z0-9_]+)/ {print $1}')

    # Generate possible matches and store them in the
    # array variable COMPREPLY
    COMPREPLY=($(compgen -W "${cmds}" $cur))
}

# Assign the auto-completion function for our command.
complete -F _gypaver gypaver
