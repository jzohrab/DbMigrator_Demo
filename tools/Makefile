init:
	pip install -r requirements.txt

# All commands here are executing on the db without checking the
# target.  Add checks to ensure that the changes aren't executed
# against a prod database.

# Make a new db.
n:
	python migrate.py -nsu

# Run migrations, fix code objects, fix baseline data.
m:
	python migrate.py -mcd

.PHONY: all test clean venv
