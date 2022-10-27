CREATE USER 'radius'@'%' IDENTIFIED BY 'test';

GRANT SELECT ON db_radius.* TO 'radius'@'%';

GRANT ALL on db_radius.radacct TO 'radius'@'%';
GRANT ALL on db_radius.radpostauth TO 'radius'@'%';
