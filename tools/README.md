# Database migration.

Run migrations in the ../schema folder with `python migrate.py <args>`


````
> python migrate.py -h
usage: migrate.py [-h] [-n] [-s] [-m] [-c] [-d] [-u] [db [db ...]]

Migrate one or more databases (or default database, if one is assigned).

positional arguments:
  db                name of database to manipulate

optional arguments:
  -h, --help        show this help message and exit
  -n, --new         Create new (empty) database(s)
  -s, --schema      Run baseline schema(e)
  -m, --migrations  Run migrations
  -c, --code        Run code (for views, stored procs, etc)
  -d, --data        Load reference (bootstrap) data
  -u, --update      Updates database (runs migrations, code, and data)
````
