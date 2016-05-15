# Show the items covered.
clear

echo "Build new, fully migrated database: "
read i
make db_all
echo
echo "Run all tests (model, db): "
read i
make test
echo
echo "Run backwards-compatibility check of db with prod code: "
read i
./test/setup_compat_test.sh master development
echo
echo "Run forwards-compatibility check with pending branches: "
read i
./tools/setup_forward_compat_work_env.sh origin/pending_20160901_drop_obsolete_talk_speaker
echo
echo "Start the app:"
read i
make seed
python -m flaskapp.app &
open -a 'Google Chrome' 'http://127.0.0.1:5000/'  # Mac OSX only
