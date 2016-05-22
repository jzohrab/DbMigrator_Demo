# Set up conditions for a compatibility test:

# 1. Detached-head checkout a given sha, copy the schema dir.
# 2. Detached-head checkout a different sha, replace existing schema
#    dir with that from step 1.
# 3. Rebuild the database, and run the tests.

# If all tests pass, you can assume that the code in step 2
# will work with the schema from step 1.

if [ "$#" -lt "2" ]; then
    cat <<EOF

This script checks that the db schema as at commit 'db_sha'
will work with the application code as at commit 'code_sha'.

Usage:

  $ $0 <db_sha> <code_sha>

Example:

  Branch of dev db schema:  development
  Branch currently in prod: master

  $ $0 development master

You can also use SHAs instead of branch names.

To pause in between each step, add a third argument (value doesn't matter)

EOF
    exit 1
fi

if [ ! -d ./schema ]; then
    echo This script must be run in the parent of the 'schema' directory.
    exit 1
fi

db_sha="$1"
code_sha="$2"
pause="$3"

pause() {
    if [ -n "$1" ]; then
	echo '    (hit key to continue)'
	read i
    fi
}

echo
echo === Checking out database as at $db_sha
git checkout $db_sha --detach 2>/dev/null
pause $pause
echo
echo === Storing schema
mv schema tmp_proposed_schema > /dev/null
pause $pause
echo
echo === Checking out code as at $code_sha
git checkout $code_sha --detach 2>&1 > /dev/null
pause $pause
echo
echo === Replacing schema with schema from $db_sha
mv tmp_proposed_schema schema > /dev/null
pause $pause
echo
echo === Rebuild db
make db_all
pause $pause
echo
echo === Run all the tests
git clean -f >/dev/null
make test
echo
git checkout $db_sha
