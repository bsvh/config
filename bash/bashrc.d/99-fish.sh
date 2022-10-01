# Use fish as the interactive shell
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && $(which fish 2>/dev/null) && -z ${BASH_EXECUTION_STRING} ]]
then
    exec fish
fi
