import unittest

import event.repository
from event.repository import Repository
from event.model import Talk
import db_helpers

class Talk_Tests(unittest.TestCase):

    def setUp(self):
        self.repo = Repository()
        h = db_helpers.Helpers()
        h.clean_out_unittest_db()

    def test_smoke_test_can_save_and_retrieve_a_talk(self):
        t1 = Talk()
        t1.title = 'Supertalk'
        t1.speaker = 'John Smith'
        self.repo.save(t1)
        t = self.repo.get_talk('Supertalk')
        self.assertEqual('Supertalk',t.title)
        self.assertEqual('John Smith',t.speaker)

    def test_cant_save_the_same_talk_title_twice(self):
        t1 = Talk()
        t1.title = 'Supertalk'
        t1.speaker = 'John Smith'
        self.repo.save(t1)
        with self.assertRaises(event.repository.DbException):
            self.repo.save(t1)
