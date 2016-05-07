-- talk.talk_speaker was split into talk_speaker_first and talk_speaker_last,
-- and existing clients should have migrated off of it.

drop trigger trg_compat_talk_speaker_INSERT;
drop trigger trg_compat_talk_speaker_UPDATE;

alter table talk drop column talk_speaker;
