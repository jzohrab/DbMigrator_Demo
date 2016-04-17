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

    def __execute(self, sql, prms):
        """Executes sql, Throws on error."""
        conn = self.__get_open_connection()
        conn.autocommit(True)
        cursor = conn.cursor()
        try:
            cursor.execute(sql, prms)
            return cursor.fetchall()
        except Exception as e:
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
        self.connection_hash = {
            'host': c['host'],
            'user': c['user'],
            'password': c['password'],
            'dbname': c['dbname']
        }

    def save(self, o):
        if type(o) == model.Talk:
            sql = "insert into talk(talk_title, talk_speaker) values (%s, %s)"
            self.__execute(sql, (o.title, o.speaker))
        else:
            raise ValueError('Don''t know how to save a {0}'.format(o))

    def get_talk(self, title):
        sql = "select * from talk where talk_title = %s"
        d = self.__execute(sql, [title])[0]
        t = model.Talk()
        t.id = d[0]
        t.title = d[1]
        t.speaker = d[2]
        return t
