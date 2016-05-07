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
