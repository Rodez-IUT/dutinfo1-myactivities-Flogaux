CREATE OR REPLACE FUNCTION add_activity_with_title(title VARCHAR(200)) returns bigint AS $$
 INSERT INTO activity VALUES(nextval('id_generator'), title)
 returning id
$$ Language SQL
