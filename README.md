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
from that in the `tools` directory).

```
$ virtualenv venv
$ source venv/bin/activate
$ make init
```

## Database migrations

The database migrations are handled with DbMigrator, run in a
virtualenv in `tools`.

Set everything up and run the first round of migrations:

```
$ virtualenv venv
$ source venv/bin/activate
$ make init
$ python tools/migrate.py -nsu
```
