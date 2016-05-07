import unittest

from event.model import Talk

class Talk_Tests(unittest.TestCase):

    def test_set_get_title(self):
        # This is not a useful test!
        t1 = Talk()
        t1.title = 'Supertalk'
        self.assertEqual('Supertalk',t1.title)

    def test_get_set_speaker(self):
        t1 = Talk()
        t1.speaker_first = 'John'
        t1.speaker_last = 'Smith'
        self.assertEqual('John Smith',t1.speaker)
