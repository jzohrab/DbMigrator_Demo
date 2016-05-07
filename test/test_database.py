# Database-level tests

import MySQLdb
import os
from configobj import ConfigObj
import unittest
import db_helpers

class Database_Tests(unittest.TestCase):

    def test_smoke_test_queries(self):
        """Smoke test, ensure the queries run!"""
        queries = ['v_talks_by_difficulty']
        h = db_helpers.Helpers()
        for q in queries:
            h.execute('select * from ' + q, [])

class Talk_Speaker_Trigger_Tests(unittest.TestCase):
    """split talk.talk_speaker into talk_speaker_first, talk_speaker_last.

    Doing database-level inserts for this check, need to ensure that
    any clients referring to db fields are getting what they expect.

    This is potentially brittle, but should be removed once the
    refactoring has been removed.  This code could be tagged to
    indicate it should removed, or could be removed if the test ever
    starts to fail.
    """

    def setUp(self):
        self.helpers = db_helpers.Helpers()
        self.helpers.clean_out_unittest_db()

    def test_insert_setting_old_field_updates_new_fields(self):
        sql = """insert into talk(talk_title, talk_speaker, talk_minutes)
          values ('t', 'firstname lastname', 45)"""
        self.helpers.execute(sql, [])

        sql = 'select talk_speaker_first, talk_speaker_last from talk limit 1'
        d = self.helpers.execute(sql, [])[0]
        first, last = d
        self.assertEqual(first, 'firstname')
        self.assertEqual(last, 'lastname')

    def test_insert_setting_new_fields_updates_old_field(self):
        sql = """insert into talk(talk_title, talk_speaker_first, talk_speaker_last, talk_minutes)
          values ('t', 'firstname', 'lastname', 45)"""
        self.helpers.execute(sql, [])

        sql = 'select talk_speaker from talk limit 1'
        d = self.helpers.execute(sql, [])[0]
        self.assertEqual(d[0], 'firstname lastname')

    def test_update_old_field_updates_new_and_vic_versa(self):
        sql = """insert into talk(talk_title, talk_speaker, talk_minutes)
          values ('t', 'firstname lastname', 45)"""
        self.helpers.execute(sql, [])
        sql = "update talk set talk_speaker = 'john smith'"
        self.helpers.execute(sql, [])
        sql = 'select talk_speaker_first, talk_speaker_last from talk limit 1'
        d = self.helpers.execute(sql, [])[0]
        first, last = d
        self.assertEqual(first, 'john')
        self.assertEqual(last, 'smith')

        sql = "update talk set talk_speaker_first = 'john', talk_speaker_last = 'snow'"
        self.helpers.execute(sql, [])
        sql = 'select talk_speaker from talk limit 1'
        d = self.helpers.execute(sql, [])[0]
        self.assertEqual(d[0], 'john snow')
