import unittest

from event.repository import Repository
from event.model import Talk

class Talk_Tests(unittest.TestCase):

    def test_smoke_test_can_save_and_retrieve_a_talk(self):
        t1 = Talk()
        t1.title = 'Supertalk'
        t1.speaker = 'John Smith'
        r = Repository()
        r.save(t1)
        t = r.get_talk('Supertalk')
        self.assertEqual('Supertalk',t.title)
        self.assertEqual('John Smith',t.speaker)

