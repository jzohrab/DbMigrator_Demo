CREATE TABLE difficulty (
  difficulty_id smallint NOT NULL,
  difficulty_name varchar(10),
  difficulty_sort smallint NOT NULL,
  PRIMARY KEY (difficulty_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- placeholder record to allow for ref. integ.
-- from talk table to difficulty.
-- will be updated with the reference data.
insert into difficulty(difficulty_id, difficulty_name, difficulty_sort)
values (-1, 'n/a', 0);

alter table talk add difficulty_id smallint not null default -1;

alter table talk add constraint fk_difficulty_id
foreign key (difficulty_id) references difficulty(difficulty_id);
