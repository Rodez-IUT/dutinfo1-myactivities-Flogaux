CREATE OR REPLACE FUNCTION register_user_on_activity(userID bigint, activity bigint ) RETURNS registration AS $$

DECLARE
    variable registration%rowtype;
BEGIN
    select * into variable from registration where user_id = userID AND activity_id  = activity;
    if not found then
	    INSERT INTO registration (id,user_id, activity_id)
        VALUES (nextval('id_generator'), userID, activity);
	    SELECT * INTO variable 
        FROM registration
        WHERE user_id = userID
        AND activity_id = activity; 
        RETURN variable;
    else  
        RAISE EXCEPTION 'registration already exists';
    end if;
END;

$$ Language plpgsql;

DROP TRIGGER IF EXISTS add_log ON registration;
CREATE OR REPLACE FUNCTION notifie_add() RETURNS trigger AS $action_log$

BEGIN
    INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
    VALUES (nextval('id_generator'), 'insert', 'registration', NEW.id , 'postgres', NOW()); 
    RETURN NULL;
END;
$action_log$ LANGUAGE plpgsql;

CREATE TRIGGER add_log AFTER INSERT ON registration
    FOR EACH ROW EXECUTE PROCEDURE notifie_add();
