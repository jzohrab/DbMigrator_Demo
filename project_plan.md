# Project plan

- Add talk (talk, description, speaker, duration)
- browse talks
- Add slots (date, time, duration)
- Get candidates

- new feature: talk ratings - easy, medium, hard (baseline data)
- add to cli

- view for possible talks per slot (filtered by difficulty)
- introduce "code objects" - _don't_ want these to be `drop/recreate/alter`
  - dev A wants to sort by difficulty, dev B wants to add the duration

- launch to prod
- baselining

- new feature: slot max difficulty
- new delta
- launch DB changes to prod ahead of time
- backwards compatibility tests

- refactoring: change the speaker to speaker_first, speaker_last
- want to launch the db changes ahead of time, and so can't drop the old field; also may have other clients
- add trigger to table: insert to 'speaker' should go to speaker_first and _last
- tests ok?
- same process as before, backwards compat testing

- have accumulated cruft - so, schedule a change upcoming, committed into the schema as "upcoming"
- test forwards compatibility - try applying the db change to the schema, and run tests


- dba changes:
- base knowledge, or script to test out a change

- encapsulation of db
- multiple clients sharing db - APIs belong with the DB project, not with the clients
