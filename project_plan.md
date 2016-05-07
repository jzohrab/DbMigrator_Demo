# Project plan

## 1. POC

OK - Add talk (title, speaker, duration)
OK - view talks

OK - launch to prod
OK - rebaselining


## 2. Add feature, compatability tests

OK - new feature: talk ratings - easy, medium, hard (baseline data)
OK - new delta
OK - add to cli
OK - launch DB changes to prod ahead of time
OK - backwards compatibility tests


## 3. Code objects

OK - view for difficult talks
OK - introduce "code objects" - _don't_ want these to be `drop/recreate/alter`
     - dev A wants to sort by difficulty, dev B wants to add the duration


## 4. Refactoring

OK - refactoring: change the speaker to speaker_first, speaker_last
OK - want to launch the db changes ahead of time, and so can't drop the old field; also may have other clients
OK - add trigger to table: insert to 'speaker' should go to speaker_first and _last
OK - tests ok?
OK - same process as before, backwards compat testing


## 5. Scheduling future changes

- have accumulated cruft - so, schedule a change upcoming, committed into the schema as "upcoming"
- test forwards compatibility - try applying the db change to the schema, and run tests

