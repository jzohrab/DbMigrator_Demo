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

git merge $pending_branch --no-ff --no-commit
git reset HEAD
python migrate.py -m

# Schema changes are in the parent folder's subfolders.
pushd ..
git clean -f
popd

cat <<EOF
Fix any db build issues, and rerun this script.
If there were no db-build issues, run the unit tests.
If all tests pass, this branch is assumed to be
forwards-compatible with the database changes.
EOF
