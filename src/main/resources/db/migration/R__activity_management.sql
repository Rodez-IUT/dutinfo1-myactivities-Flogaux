CREATE OR REPLACE FUNCTION add_activity(in_title VARCHAR(200), in_description text, in_owner_id bigint DEFAULT NULL) RETURNS activity AS $$

DECLARE
    variable activity%rowtype;
    defaultOwnerUsername varchar(500) := 'Default Owner';
BEGIN
    if in_owner_id IS NULL then  
       select id into in_owner_id from "user" where username = defaultOwnerUsername; 
     end if;
        
        INSERT INTO activity (id, title , description, creation_date, owner_id)
        VALUES (nextval('id_generator'), in_title , in_description, NOW(), in_owner_id);
	    SELECT * INTO variable 
        FROM activity
        WHERE owner_id = in_owner_id 
        AND title = in_title; 
        RETURN variable; 
  
END;

$$ Language plpgsql;
CREATE OR REPLACE FUNCTION find_all_activities(INOUT activities_curs refcursor) AS $$
BEGIN
      OPEN activities_curs FOR 
          SELECT act.id, title, description, creation_date, modification_date,owner_id, us.username
          FROM activity act
          LEFT JOIN "user" us
          ON act.owner_id = us.id 
          ORDER BY title,us.username;          
      Return;
END;
$$ Language plpgsql;
