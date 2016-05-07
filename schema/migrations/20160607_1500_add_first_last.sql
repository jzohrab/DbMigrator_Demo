-- split talk.talk_speaker into talk_speaker_first and talk_speaker_last.

alter table talk add talk_speaker_first varchar(100) null;
alter table talk add talk_speaker_last varchar(100) null;

update talk set
talk_speaker_first = substring_index(substring_index(talk_speaker, ' ', 1), ' ', -1),
talk_speaker_last  = substring_index(substring_index(talk_speaker, ' ', 2), ' ', -1);


-- Calling the trigger 'trg_compat' to indicate that this trigger is
-- strictly for compatibility and will be removed.
-- This is demo code only, it doesn't check inputs/conditions enough.
-- The code is also verbose, but that doesn't matter for temporary/stopgap code.
-- Tests are in test/test_database.py
create trigger trg_compat_talk_speaker_INSERT before insert on talk
for each row
  begin
    if new.talk_speaker is not null then
      set new.talk_speaker_first = substring_index(substring_index(new.talk_speaker, ' ', 1), ' ', -1);
      set new.talk_speaker_last = substring_index(substring_index(new.talk_speaker, ' ', 2), ' ', -1);
    else
      set new.talk_speaker = concat(new.talk_speaker_first, ' ', new.talk_speaker_last);
    end if;
  end;

create trigger trg_compat_talk_speaker_UPDATE before update on talk
for each row
  begin
    if new.talk_speaker <> old.talk_speaker then
      set new.talk_speaker_first = substring_index(substring_index(new.talk_speaker, ' ', 1), ' ', -1);
      set new.talk_speaker_last = substring_index(substring_index(new.talk_speaker, ' ', 2), ' ', -1);
    else
       set new.talk_speaker = concat(new.talk_speaker_first, ' ', new.talk_speaker_last);
    end if;
  end;
