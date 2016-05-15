# Set up conditions for forwards compatibility work:

# 1. Merge a pending database change branch, but do not commit it
# 2. Run (or attempt to run) the database migrations on the current database
# 3. Discard the pending change.

# There are a few improvements that should be made with this script:

# - script does a 'reset HEAD' in the middle of it.  Should check if
#   there are pending files that should be committed beforehand.
# - step 3 will remove all untracked files!  Should tell the user
#   this and fail out early if there are untracked files present.

if [ "$#" -ne "1" ]; then
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


EOF
    exit 1
fi

pending_branch="$1"

# Merge, ensure fail on error.
set -e  # needs testing to ensure this actually works as expected
        # ref gotchas at http://mywiki.wooledge.org/BashFAQ/105
git merge $pending_branch --no-ff --no-commit

# Update db with pending changes.  Errors here will result in
# dirty git tree, may need to 'git reset --hard HEAD'
make db_update

# Drop the changes ASAP
git reset --hard HEAD

# Run tests.  If these pass, this code is forward-compatible with the
# pending changes.
make test
