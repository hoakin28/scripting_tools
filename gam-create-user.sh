#!/bin/bash 

#remove accents and non utf8 characters
gam=$(which gam)
filename=$1
declare -a NAME_MAIL
declare -a LASTNAME_MAIL
NUM=0

cat $filename | iconv -f UTF-8 -t ascii//TRANSLIT//IGNORE | sed "s/[\'\~]//g" > .tmp 
while read -r line 
do
  NAME_MAIL[$NUM]=$(echo $line | awk -F "|" '{print $1}' | awk -F " " '{print $1}' | tr '[:upper:]' '[:lower:]'| sed 's/ //g')
  LASTNAME_MAIL[$NUM]=$(echo $line | awk -F "|" '{print $2}' | awk -F " " '{print $1}'| tr '[:upper:]' '[:lower:]'| sed 's/ //g')  
  NAME=$(echo $line | awk -F "|" '{print $1}' | sed 's/^ //g')
  LASTNAME=$(echo $line | awk -F "|" '{print $2}' | sed 's/^ //g')
  PASSWORD='T3mP0r4L'
  RANDOMIZER=$[ $RANDOM % 512 ] 
  python $gam create user "${NAME_MAIL[$NUM]}"_"${LASTNAME_MAIL[$NUM]}" firstname "$NAME" lastname "$LASTNAME" password "$PASSWORD-$RANDOMIZER" changepassword on suspended off
  echo "$PASSWORD-$RANDOMIZER"
  let 'NUM++'
done < ".tmp"
rm .tmp
for (( i=0 ; i<${#NAME_MAIL[@]} ; i++ ))
do
	echo "${NAME_MAIL[$i]}"_"${LASTNAME_MAIL[$i]}"
done
