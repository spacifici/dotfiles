#!/bin/bash

# Add this as a crontab job to synchronize any git repo periodically
#
# 15,45‿*‿*‿*‿*‿/home/user/bin/autopush.sh‿/home/user/repository

declare -r REPO=$(readlink -f "$1")
changed=$(cd "$REPO" && git status --porcelain 2>/dev/null)

test $? -eq 0 || { echo "Not a git repository: $REPO" && exit 1; }

if [[ -n "$changed" ]]; then
    msg=$(date "+Changes on %F at %H:%M")
    (cd "$REPO" && git add . && git commit -m "$msg") &>/dev/null
    test $? -eq 0 || { echo "Adding to stage files in $REPO failed" && exit 1; }
fi

# Pull rebase
(cd "$REPO" && git pull --rebase -s recursive -X theirs) &>/dev/null
test $? -eq 0 || { echo "Pull rebase failed" && exit 1; }

# Finally push
(cd "$REPO" && git push) &>/dev/null
test $? -eq 0 || { echo "Push failed" && exit 1; }
