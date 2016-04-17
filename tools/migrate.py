"""Database migration."""

import sys
import os
import inspect

import DbMigrator
from DbMigrator.driver import Driver
from DbMigrator.defaultdatabasesource import DefaultDatabaseSource
from DbMigrator.mysqldatabasehandler import MySqlDatabaseHandler

def build_driver():
    f = inspect.getfile(inspect.currentframe())
    this_dir = os.path.dirname(os.path.abspath(f))
    inifile = os.path.join(this_dir, 'conn.ini')
    if not os.path.exists(inifile):
        inifile = inifile + '.template'
    if not os.path.exists(inifile):
        raise Exception("Missing ini file at " + inifile)
    schema_root_dir = os.path.normpath(os.path.join(this_dir, '..'))
    dds = DefaultDatabaseSource(inifile, schema_root_dir)
    driver = Driver(dds, MySqlDatabaseHandler())
    driver.default_database = "schema"
    driver.is_debug_printing = True
    return driver

def main():
    d = build_driver()
    d.main(sys.argv)

if __name__ == '__main__':
    main()
