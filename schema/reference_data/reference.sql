-- Reference data.
-- Script must be idempotent.

-- This file shows one way to load data, and ensure it's up-to-date.
-- Other ways that this idempotent load could be handled:
--   via code (using domain model; may not be possible under certain conditions)
--   create and drop stored procedures at start/end of this process


create temporary table tmp_difficulty (
  difficulty_id smallint NOT NULL,
  difficulty_name varchar(10),
  difficulty_sort smallint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into tmp_difficulty(difficulty_id, difficulty_name, difficulty_sort)
values
(1, 'low', 1),
(2, 'medium', 2),
(3, 'high', 3);

-- Insert missing data (warning: this is an inefficient query):
insert into difficulty(difficulty_id, difficulty_name, difficulty_sort)
select t.difficulty_id, t.difficulty_name, t.difficulty_sort
from tmp_difficulty t
where t.difficulty_id not in (select difficulty_id from difficulty);

-- Update data that may have changed.
UPDATE difficulty AS d
INNER JOIN tmp_difficulty AS t ON d.difficulty_id = t.difficulty_id
SET
d.difficulty_name = t.difficulty_name,
d.difficulty_sort = t.difficulty_sort;
