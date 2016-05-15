# Setup
init:
	pip install -r requirements.txt

# Run all tests
test: clean
	python -m unittest discover

# Run model-only tests
test_model: clean
	python -m unittest test.test_model

# Run database-only tests
test_db: clean
	python -m unittest test.test_repository

# Seed db with sensible dev data
seed:
	python -m test.db_helpers

clean:
	find . -name '*.pyc' -exec rm -f {} +

# Start the flask app
flask:
	python -m flaskapp.app

# ==============
# Database

# All commands here are executing on the db without checking the
# target.  Add checks to ensure that the changes aren't executed
# against a prod database.


db_new:
	python tools/migrate.py --new

db_base:
	python tools/migrate.py --schema

db_migrate:
	python tools/migrate.py --migrations

db_code:
	python tools/migrate.py --code

db_data:
	python tools/migrate.py --data

db_update:
	python tools/migrate.py --update

db_all:
	python tools/migrate.py -nsu

# Dump the current db schema without data (for baselining)
# Hardcoding username, password, and DB name for demo only.
db_rebaseline:
	mysqldump -d -u user -ppasswd --no-data mysql_test > schema/baseline_schema/Db.sql
	mkdir -p schema/old_migrations/
	git mv schema/migrations/*.sql schema/old_migrations/

#######

.PHONY: all test clean venv
