# GRANTs: User radius
GRANT
    SELECT
ON db_radius.* TO 'radius'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
on db_radius.radacct TO 'radius'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
on db_radius.radpostauth TO 'radius'@'%';


#######################################
# Create and GRANTs: secondary User (Opcional).
## User for safe use of tables.

CREATE USER IF NOT EXISTS '$USENAME'@'%' IDENTIFIED BY '$PASSWORD';

GRANT 
    SELECT
ON db_radius.* TO '$USENAME'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
ON db_radius.radcheck TO '$USENAME'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
ON db_radius.radgroupcheck TO '$USENAME'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
ON db_radius.radgroupreply TO '$USENAME'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
ON db_radius.radreply TO '$USENAME'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
ON db_radius.radusergroup TO '$USENAME'@'%';

GRANT 
    DELETE,
    INSERT,
    UPDATE
ON db_radius.nas TO '$USENAME'@'%';