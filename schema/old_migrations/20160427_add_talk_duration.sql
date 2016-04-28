alter table talk add column talk_minutes integer;

update talk set talk_minutes = 0;

alter table talk modify talk_minutes integer not null;

