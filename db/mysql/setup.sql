
/*
 * GRANTs: User radius
 */

GRANT
    SELECT
ON db_radius.* TO 'radius_user'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
on db_radius.radacct TO 'radius_user'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
on db_radius.radpostauth TO 'radius_user'@'%';

