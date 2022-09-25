#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ -z $1 ]]
 then
 echo -e "Please provide an element as an argument."
 else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
   ELEMENT_RESULT="$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")"
  else
   ELEMENT_RESULT="$($PSQL "SELECT name FROM elements WHERE symbol='$1'")"
   if [[ -z $ELEMENT_RESULT ]]
    then
     ELEMENT_RESULT="$($PSQL "SELECT name FROM elements WHERE name='$1'")"
    fi
  fi
  if [[ -z $ELEMENT_RESULT ]]
  then
   echo "I could not find that element in the database." 
  else
   ELEMENT_ATOMIC_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT_RESULT'")"
   ELEMENT_SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE name='$ELEMENT_RESULT'")"
   ELEMENT_TYPE="$($PSQL "SELECT types.type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")"
   ELEMENT_ATOMIC_MASS="$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")"
   ELEMENT_MELTING_POINT="$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")"
   ELEMENT_BOILING_POINT="$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")"
   echo  "The element with atomic number $ELEMENT_ATOMIC_NUMBER is $ELEMENT_RESULT ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_ATOMIC_MASS amu. $ELEMENT_RESULT has a melting point of $ELEMENT_MELTING_POINT celsius and a boiling point of $ELEMENT_BOILING_POINT celsius."
  fi
   
fi
