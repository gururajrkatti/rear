# This file is part of Relax-and-Recover, licensed under the GNU General
# Public License. Refer to the included COPYING for full text of license.
#
# 800_prune_old_backups.sh

# User might specify some additional output options in Borg.
# Output shown by Borg is not controlled by `rear --verbose` nor `rear --debug`
# only, if BORGBACKUP_SHOW_PROGRESS is true.
local borg_additional_options=''

is_true $BORGBACKUP_SHOW_PROGRESS && borg_additional_options+='--progress '
is_true $BORGBACKUP_SHOW_STATS && borg_additional_options+='--stats '
is_true $BORGBACKUP_SHOW_LIST && borg_additional_options+='--list '
is_true $BORGBACKUP_SHOW_RC && borg_additional_options+='--show-rc '

if [ ! -z $BORGBACKUP_OPT_PRUNE ]; then
    # Prune old backup archives according to user settings.
    if is_true $BORGBACKUP_SHOW_PROGRESS; then
        borg_prune 0<&6 1>&7 2>&8
    elif is_true $VERBOSE; then
        borg_prune 0<&6 1>&7 2> >(tee >(cat 1>&2) >&8)
    else
        borg_prune 0<&6 1>&7
    fi

    StopIfError "Borg failed to prune old backup archives, borg rc $?!"
else
    # Pruning is not set.
    Log "Pruning of old backup archives is not set, skipping."
fi
