CREATE OR REPLACE FUNCTION notifie_delete() RETURNS trigger AS $action_log$
DECLARE

BEGIN
    INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
    VALUES (nextval('id_generator'), 'delete', 'activity', OLD.id, 'postgres', NOW()); 
    RETURN NULL;
END;
$action_log$ LANGUAGE plpgsql;

CREATE TRIGGER delete_log AFTER DELETE ON activity
    FOR EACH ROW EXECUTE PROCEDURE notifie_delete();