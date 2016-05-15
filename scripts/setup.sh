# Create various branches
#
# Since the main "development" branch is periodically rebased, this
# script uses the commit comments to create the branches (!).  The
# comments will be more stable than the shas.

git checkout master

# The branch assumes that your master is up-to-date, otherwise, do the following:
# git fetch origin
# git merge origin/master

PRODSHA=`git log --oneline | grep 'Re-baselining schema' | awk '{ print $1 }'`
DEVSHA=`git log master -n 1 --oneline | awk '{ print $1 }'`
DEMO_BKWDCOMPATSHA=`git log --oneline | grep 'talk difficulty to model, tests' | awk '{ print $1 }'`
DEMO_FWDCOMPATFAILSHA=`git log --oneline | grep 'use refactored db fields' | awk '{ print $1 }'`

function showsha() {
    comment=`git log $2 -n 1 --oneline`
    echo "$1: $comment"
}

echo
echo Demo branchs:
showsha dev $DEVSHA
showsha prod $PRODSHA
showsha bkwds-compat $DEMO_BKWDCOMPATSHA
showsha fwds-compat-fail $DEMO_FWDCOMPATFAILSHA
echo

if [ "$#" != "1" ]; then
    echo This is going to create branches with the shas above.  Double-check these SHAs are ACTUALLY CORRECT!
    echo
    echo If yes, run this again, with any argument, e.g.:
    echo   $ $0 force
    echo
    exit 1
fi

function makebranch() {
    echo
    echo CREATING BRANCH: $1
    git checkout master
    git branch -D $1  # Delete existing
    git checkout -b $1
    git reset --hard $2
    echo
}

makebranch demo_prod $PRODSHA
makebranch demo_alice $DEMO_BKWDCOMPATSHA
makebranch demo_dev $DEVSHA
makebranch demo_2_bkwd_compat $DEMO_BKWDCOMPATSHA
makebranch demo_3_fwd_compat $DEMO_FWDCOMPATFAILSHA

# Prep pending change.
# Pending change is created new refactored fields are added, so the change
# would be committed to a separate branch from that SHA.
makebranch pending_change $DEMO_BKWDCOMPATSHA
git checkout pending_change
cat <<EOF > schema/migrations/20160901_drop_obsolete_talk_speaker.sql
-- talk.talk_speaker was split into talk_speaker_first and talk_speaker_last,
-- and existing clients should have migrated off of it.

drop trigger trg_compat_talk_speaker_INSERT;
drop trigger trg_compat_talk_speaker_UPDATE;

alter table talk drop column talk_speaker;
EOF
git add schema/migrations/20160901_drop_obsolete_talk_speaker.sql
git commit -m "Pending change to be incorporated"

# Set up for the first demo, an end-to-end run.
# first we start off with what's already launched, my branch
git checkout demo_prod
