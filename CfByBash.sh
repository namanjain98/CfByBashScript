#!/bin/bash
echo "enter region"
read reg
echo "enter stack name"
read SN
if ! aws cloudformation describe-stacks --region $reg --stack-name $SN 2>/dev/null 
then

  echo -e "\nStack does not exist, creating ..."
  aws cloudformation create-stack --region $reg --stack-name $SN --template-body file://sBucket.json

  echo "Waiting for stack to be created ..."
  aws cloudformation wait stack-create-complete --region $reg --stack-name $SN 

else

  echo -e "\nStack exists, attempting update ...."
  update_output=$(aws cloudformation deploy --template-file sBucket.json --stack-name $SN)2>/dev/null
  if [ "$?" -ne 0 ]; then
    echo "The stack is completely updated"
  else
    echo "updation complete"
fi

fi