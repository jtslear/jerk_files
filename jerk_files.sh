#!/bin/bash

# Let's find files at $1
# files that are modified over 7 day (mtime = n*24)
# let's move them to a new lodcation ($2)
# Mind your trailing \'s!!!

# functions
function logMsg {
if [ "$#" = "0" ]; then
  echo "$0 failed to log a message"
else
`logger -t "$0 " -i $1`
fi
}

# function that moves things:
function jerkData {
if [ "$1" == "move" ]; then
  `find $SOURCE_OBJECT -type f -mtime +7 -exec mv {} $DESTINATION_OBJECT \;`
elif [ "$1" == "delete" ]; then
  `find $SOURCE_OBJECT -type f -mtime +7 -exec rm -rf {} \;`
else
  logMsg "Unsure of what to accomplish"
  exit
fi
}

function validateInput() {
if [ $1 ] && [ $2 ]; then
  if [ $1 == "delete" ]; then
    return "1"
  elif [ $3 ]; then
    pritnHelp
  fi
else
  echo $1
  echo $2
  printHelp
fi
}

function printHelp {
echo "$0 is expecting 3 arguments"
echo "Usage:"
echo "$0 {move|delete} {target} {destination}"
exit
}

logMsg "begin" 
validateInput $1 $2 $3
ACTION_DESIRED=$1
SOURCE_OBJECT=$2
DESTINATION_OBJECT=$3

jerkData $ACTION_DESIRED $SOURCE_OBJECT $DESTINATION_OBJECT

logMsg "end" 
