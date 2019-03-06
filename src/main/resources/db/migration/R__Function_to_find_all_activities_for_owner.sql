CREATE OR REPLACE FUNCTION find_all_activities_for_owner(ownername varchar(500)) RETURNS SETOF activity AS $$
  SELECT act.*            --utilisation de l'alias avec ''alias.''
  FROM activity act       -- creation d'un alias pour la table activity
  JOIN "user" owner       -- création d'un alias pour la table user (entre guillemet car user est un mot reservé de postgresql) 
  ON owner_id= owner.id 
  WHERE owner.username = ownername;
$$ LANGUAGE SQL;