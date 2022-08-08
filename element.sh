#!/bin/bash

PSQL="psql -U freecodecamp periodic_table --tuples-only -c"

# Return function
RETURN_STUFF() {
  # If -z: print message
  if [[ -z "$ELEMENT_QUERY" ]]
  then
    echo "I could not find that element in the database."
    
  else
    # Print the element 
    echo "$ELEMENT_QUERY" | while read ATOM BAR SYMBOL BAR NAME BAR TYPE BAR ATOM_MASS BAR M_POINT BAR B_POINT
    do
      echo "The element with atomic number $ATOM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOM_MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
    
    done
  fi
}

# Check empty input
if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."

elif [[ $1 =~ ^[0-9]+$ ]]
then
  # Extract row from db using INPUT == int.
  ELEMENT_QUERY=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  RETURN_STUFF

else
  # Extract row from db using INPUT == string.
  ELEMENT_QUERY=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  RETURN_STUFF

fi
