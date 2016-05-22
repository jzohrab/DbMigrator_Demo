# Set up conditions for forwards compatibility work:

# 1. Merge a pending database change branch, but do not commit it
# 2. Run (or attempt to run) the database migrations on the current database
# 3. Discard the pending change.

# There are a few improvements that should be made with this script:

# - script does a 'reset HEAD' in the middle of it.  Should check if
#   there are pending files that should be committed beforehand.
# - step 3 will remove all untracked files!  Should tell the user
#   this and fail out early if there are untracked files present.

if [ "$#" -lt "1" ]; then
    cat <<EOF

This script builds a new database environment using the
commits in the specified pending branch.  If the db build
fails, then either the change was bad, or something in
the schema is referring to entities that will be altered.

If the db build succeeds, the application tests should be
run and any failures fixed.

Usage:

  $ $0 <pending_branch>

Example:

  $ $0 origin/pending_20160901_drop_obsolete_talk_speaker

To pause in between each step, add a second argument (value doesn't matter)

EOF
    exit 1
fi

if [ ! -d ./schema ]; then
    echo This script must be run in the parent of the 'schema' directory.
    exit 1
fi

pending_branch="$1"
pause="$2"

pause() {
    if [ -n "$1" ]; then
	echo '    (hit key to continue)'
	read i
    fi
}

echo
echo === Merge $pending_branch without committing
# Merge, ensure fail on error.
set -e  # needs testing to ensure this actually works as expected
        # ref gotchas at http://mywiki.wooledge.org/BashFAQ/105
git merge $pending_branch --no-ff --no-commit
pause $pause
echo

echo === Update db per $pending_branch
# Update db with pending changes.  This step may fail, meaning
# that there are some code objects, or current schema, that
# are incompatible with the pending db changes.
set +e
make db_update
set -e
pause $pause
echo

echo === Remove $pending_branch changes from current code branch
git reset --hard HEAD
pause $pause
echo

echo === Run all the tests
# This is clumsy, as it runs the tests even if the db build fails ...
# it should abort and cleanup.  The tests could pass, even if
# the db build fails.
# If the build passes, and the tests pass, this code is
# forward-compatible with the pending changes.
make test
