# Database layer.

import MySQLdb
import os
from configobj import ConfigObj
import model

class DbException(Exception):
    pass

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
        except MySQLdb.IntegrityError as e:
            raise DbException('error, {0}'.format(e))
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

    __talk_insert = """insert into talk(talk_title, talk_speaker_first, talk_speaker_last, talk_minutes, difficulty_id)
      values (%s, %s, %s, %s, (select difficulty_id from difficulty where difficulty_name = %s))"""

    __talk_select = """select
      t.talk_id, t.talk_title, t.talk_speaker_first, t.talk_speaker_last, t.talk_minutes, d.difficulty_name
      from talk t inner join difficulty d on d.difficulty_id = t.difficulty_id"""

    def save(self, o):
        if type(o) == model.Talk:
            self.__execute(Repository.__talk_insert, (o.title, o.speaker_first, o.speaker_last, o.minutes, o.difficulty))
        else:
            raise ValueError('Don''t know how to save a {0}'.format(o))

    def __create_talk(self, db_row):
        t = model.Talk()
        t.id, t.title, t.speaker_first, t.speaker_last, t.minutes, t.difficulty = db_row
        return t

    def get_talk(self, title):
        d = self.__execute(Repository.__talk_select + ' where talk_title = %s', [title])[0]
        return self.__create_talk(d)

    def get_all_talks(self):
        d = self.__execute(Repository.__talk_select, [])
        return map(self.__create_talk, d)
