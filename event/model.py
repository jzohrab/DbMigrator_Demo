# Model layer.

class Talk(object):

    def __init__(self):
        self.id = None
        self.title = None
        self.speaker_first = None
        self.speaker_last = None
        self.minutes = 0
        self.difficulty = 'medium'

    @property
    def speaker(self):
        return '{0} {1}'.format(self.speaker_first, self.speaker_last)
