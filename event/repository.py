# Database layer.

import MySQLdb
import os
from configobj import ConfigObj
import model

class Repository(object):

    #########
    # Helpers

    def __get_open_connection(self):
        h = self.connection_hash
        db = MySQLdb.connect(
            host=h["host"],
            user=h["user"],
            passwd=h["password"],
            db=h["dbname"]
        )
        return db

    def __execute(self, sql):
        """Executes sql, Throws on error."""
        conn = self.__get_open_connection()
        conn.autocommit(True)
        cursor = conn.cursor()
        try:
            cursor.execute(sql)
        except Exception as e:
            logger.error("Executing sql: %s"  % e)
            raise
        finally:
            cursor.close()
            conn.close()

    #########
    # API

    def __init__(self):
        d = os.path.dirname(os.path.realpath(__file__))
        ini_file = os.path.join(d, 'conn.ini')
        if not os.path.exists(ini_file):
            raise Exception("Missing ini file at " + ini_file)
        c = ConfigObj(ini_file)
        print c
        self.connection_hash = {
            'host': c['host'],
            'user': c['user'],
            'password': c['password'],
            'dbname': c['dbname']
        }

    def save(self, o):
        if type(o) == model.Talk:
            print 'save talk'
        else:
            raise ValueError('Don''t know how to save a {0}'.format(o))

    def get_talk(self, title):
        return None
