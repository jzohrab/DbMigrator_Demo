CREATE TABLE __schema_migrations (
  migration_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  script_name varchar(255) DEFAULT NULL,
  date_applied timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (migration_id),
  UNIQUE KEY migration_id (migration_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table talk
--

CREATE TABLE talk (
  talk_id mediumint(9) NOT NULL AUTO_INCREMENT,
  talk_title varchar(100) DEFAULT NULL,
  talk_speaker varchar(100) DEFAULT NULL,
  talk_minutes int(11) NOT NULL,
  PRIMARY KEY (talk_id),
  UNIQUE KEY talk_title (talk_title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
