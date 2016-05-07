# ToDevOpsDays 2016 demo

A demo MySQL project to demonstrate Agile Database ideas using
DbMigrator.

See the [Project Plan](./project_plan.md) for proposed features, and
talk content.

## Set up

1. Start MySQL, create the necessary admin user account and database
per tools/conn.ini.template.
2. Run the initial round of database migrations (see "Database migrations")
3. Set up the application (note that this is a separate `virtualenv`
from that in the `tools` directory), seed it, and start the flask app.

```
$ virtualenv venv
$ source venv/bin/activate
$ make init
$ make seed
$ make flask
```

The flask app is viewable from http://localhost:5000/

## Database migrations

The database migrations are handled with DbMigrator from the project root.

Set everything up and run the first round of migrations:

```
# Assuming that venv is set up:
$ python tools/migrate.py -nsu
```

Optionally, you can use the different `make db_*` entries, see the Makefile.

Run `python tools/migrate.py --help` to see a list of migration options.


## Checking the database

Log in as root, and connect to the db:

```
$ mysql -u root
mysql> use mysql_test
mysql> show tables;
mysql> select * from talk
```

## Backwards- and forwards-compatibility testing

Definitions:

**Backwards-compatibility testing** is when you have database changes
in the development branch that should be released into production
_ahead_ of the accompanying code.  These database changes need to be
backwards compatible with the code currently running in prod.

**Forwards-compatibility testing** is when you have database changes
scheduled several weeks or months in the future (e.g., to clean up
remnants of database refactoring).  Existing code, including code in
the development branch, will need to work with those pending changes
at some point in the future, but perhaps not immediately.

There are two scripts to demonstrate setting up your environment for
both of these tests:

* `test/setup_compat_test.sh`: for backwards-compatibility testing
* `tools/setup_forward_compat_work_env.sh`: for forwards-compat work
