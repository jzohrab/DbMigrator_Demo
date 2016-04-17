--
-- MySQL db schema, created by hand initially
--


CREATE TABLE talk (
    talk_id mediumint not null auto_increment, 
    talk_title varchar(100),
    talk_speaker varchar(100),
    primary key (talk_id)
);

