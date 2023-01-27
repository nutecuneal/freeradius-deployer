/*
 * GRANTs: User radius
 */

GRANT
    SELECT
ON db_radius.* TO 'yourdbuser'@'%';

GRANT 
    INSERT,
    UPDATE
on db_radius.radacct TO 'yourdbuser'@'%';

GRANT 
    INSERT,
    UPDATE
on db_radius.radpostauth TO 'yourdbuser'@'%';

