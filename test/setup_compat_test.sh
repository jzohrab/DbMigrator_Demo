# Set up conditions for a compatibility test:

# 1. Detached-head checkout a given sha, copy the schema dir.
# 2. Detached-head checkout a different sha, replace existing schema
#    dir with that from step 1.
# 3. Rebuild the database, and run the tests.

# If all tests pass, you can assume that the code in step 2
# will work with the schema from step 1.

if [ "$#" -ne "2" ]; then
    cat <<EOF

This script checks that the code as at commit 'code_sha'
will work with the database schema as at commit 'db_sha'.

Usage:

  $ $0 <code_sha> <db_sha>

Example:

  Git sha of code currently in prod:  2f5984
  Git sha of development db schema:   e227c9

  Combine those for testing:

  $ $0 2f5984 e227c9

You can also use branch names:

  Branch currently in prod: master
  Branch of dev db schema:  development

  $ $0 master development

EOF
    exit 1
fi

if [ ! -d ./schema ]; then
    echo This script must be run in the parent of the 'schema' directory.
    exit 1
fi

code_sha="$1"
db_sha="$2"

echo Checking out database as at $db_sha
git checkout $db_sha --detach 2>/dev/null
echo Storing schema
mv schema tmp_proposed_schema > /dev/null
echo Checking out code as at $code_sha
git checkout $code_sha --detach 2>/dev/null
echo Replacing schema with schema from $db_sha
mv tmp_proposed_schema schema > /dev/null
echo
echo Rebuild and run all tests.
# If anything fails, checkout and fix the db_sha branch.
make db_all
git clean -f >/dev/null
make test

git checkout $db_sha
