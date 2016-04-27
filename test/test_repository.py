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

        t = Talk()
        t.title = 'Supertalk'
        t.speaker = 'John Smith'
        t.minutes = 5
        self.test_talk = t

    def test_smoke_test_can_save_and_retrieve_a_talk(self):
        self.repo.save(self.test_talk)
        t = self.repo.get_talk('Supertalk')
        self.assertEqual('Supertalk',t.title)
        self.assertEqual('John Smith',t.speaker)

    def test_cant_save_the_same_talk_title_twice(self):
        self.repo.save(self.test_talk)
        with self.assertRaises(event.repository.DbException):
            self.repo.save(self.test_talk)

    def test_can_get_all_talks(self):
        self.repo.save(self.test_talk)
        talks = self.repo.get_all_talks()
        self.assertEqual(1, len(talks))
