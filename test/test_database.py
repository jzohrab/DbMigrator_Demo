# Database-level tests

import MySQLdb
import os
from configobj import ConfigObj
import unittest

class Database_Tests(unittest.TestCase):

    def __get_open_connection(self):

        d = os.path.dirname(os.path.realpath(__file__))
        ini_file = os.path.join(d, '..', 'event', 'conn.ini')
        if not os.path.exists(ini_file):
            raise Exception("Missing ini file at " + ini_file)
        c = ConfigObj(ini_file)

        if not 'test' in c['dbname']:
            raise ValueError('db name in config file must contain ''test''')

        db = MySQLdb.connect(
            host=c["host"],
            user=c["user"],
            passwd=c["password"],
            db=c["dbname"]
        )
        return db

    def __execute(self, sql, prms):
        """Executes sql, Throws on error."""
        conn = self.__get_open_connection()
        conn.autocommit(True)
        cursor = conn.cursor()
        try:
            cursor.execute(sql, prms)
            return cursor.fetchall()
        except MySQLdb.IntegrityError as e:
            raise DbException('error, {0}'.format(e))
        except Exception as e:
            raise
        finally:
            cursor.close()
            conn.close()

    def test_smoke_test_queries(self):
        """Smoke test, ensure the queries run!"""
        queries = ['v_talks_by_difficulty']
        for q in queries:
            self.__execute('select * from ' + q, [])
