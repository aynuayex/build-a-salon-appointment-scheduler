#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"


MAIN_MENU(){

SERVICES="$($PSQL "SELECT * FROM services ORDER BY service_id")"

echo -e "Welcome to My Salon, how can I help you?\n(Enter a number from the available services!)"

echo "$SERVICES" | while read SERVICE_ID BAR SERVICE 
do
echo "$SERVICE_ID) $SERVICE"
done
SERVICES
}
SERVICES() {

read SERVICE_ID_SELECTED

SERVICE_AVAILABILITY=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_AVAILABILITY ]]
then 
echo -e "I could not find that service. What would you like today?\n(Enter a number from the available services!)"

echo "$SERVICES" | while read SERVICE_ID BAR SERVICE 
do
echo "$SERVICE_ID) $SERVICE"
done
SERVICES
else
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_ID ]]
then 
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED)")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

else
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED)")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

fi
fi
}

MAIN_MENU