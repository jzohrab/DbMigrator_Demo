# Helpers

import MySQLdb
import os
from configobj import ConfigObj

import event.repository as repo
import event.model as model

class Helpers(object):

    #########
    # Helpers

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



    def seed_db(self):
        """Load db with generic data for development.

        Not a substitute for proper test setUp()."""

        r = repo.Repository()
        data = [
            ['Winter is Coming.', 'Ned Stark'],
            ['Ouch!', 'Bran Stark'],
            ['Ye Kner Nothin\', Jern Sner.', 'Ingrid'],
            ['Hodor', 'Hodor']
        ]
        for d in data:
            t = model.Talk()
            t.title = d[0]
            t.speaker = d[1]
            r.save(t)

    # Test helper methods

    def clean_out_unittest_db(self):
        self.__execute('delete from talk', ())


if __name__ == '__main__':
    print 'Setting up test data'
    h = Helpers()
    h.clean_out_unittest_db()
    h.seed_db()
