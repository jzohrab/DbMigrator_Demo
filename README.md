# ToDevOpsDays 2016 demo

A demo MySQL project to demonstrate Agile Database ideas using
[DbMigrator](https://github.com/jzohrab/DbMigrator).

**IMPORTANT NOTE: **

The code in this project is, for the most part, not good, it is for
demonstration purposes only.  Main issues, there are likely others:

- it has a half-baked ORM layer
- the database tests don't check that the connection is to a test db!


## Set up

Start MySQL, create the necessary admin user account and database
per tools/conn.ini.template.

Create the app connection settings file:

```
cp event/conn.ini.template event/conn.ini
```

Change settings as needed.

Start up virtual env, load the requirements, and create the db:

```
$ virtualenv venv
$ source venv/bin/activate
$ make init
$ make db_all
```

Seed the db with some sample data, and start the flask app:

```
$ make seed
$ make flask
```

The flask app is viewable from http://localhost:5000/

## Database migrations

The database migrations are handled with DbMigrator from the project root.

You can use the different `make db_*` entries, see the Makefile.

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

* `test/run_compat_test.sh`: for backwards-compatibility testing
* `tools/setup_forward_compat_work_env.sh`: for forwards-compat work

## Misc scripts

I scripted out most of the commands I used for the demo during the
talk.  These are in the `scripts` directory, and may be useful if
you're exploring the project independently.