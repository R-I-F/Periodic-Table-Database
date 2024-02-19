#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ -z $1 ]] 
then
  echo "Please provide an element as an argument."
else
  # check if user input is a number
  USER_INPUT=$1
  DATA_REQUEST_RESULT=""
  if [[ $USER_INPUT =~ [1-9]+ ]]
  then
    DATA_REQUEST_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $USER_INPUT")
  else
    if [[ ${#USER_INPUT} > 2 ]]
    # if user inputs helium for example
    then
      DATA_REQUEST_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$USER_INPUT'")
    else
    # if user inputs he for example
      DATA_REQUEST_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$USER_INPUT'")
    fi
  fi

  if [[ ! -z $DATA_REQUEST_RESULT ]]
  then 
    echo $DATA_REQUEST_RESULT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi