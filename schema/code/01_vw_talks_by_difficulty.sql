create or replace view v_talks_by_difficulty

as

select

t.talk_id, t.talk_title, t.talk_speaker, t.talk_minutes, d.difficulty_name
from talk t inner join difficulty d on d.difficulty_id = t.difficulty_id
order by d.difficulty_sort desc, t.talk_speaker
