#!/bin/bash

# Let's "move"
# Let's find files at $1
# files that are modified over 7 day (mtime = n*24)
# Check and see if the proper archive dir exists uner $2
# let's move them to the new lodcation 
# Mind your trailing \'s!!!

# functions
function logMsg {
if [ "$#" = "0" ]; then
  echo "$0 failed to log a message"
else
  `logger -t "$0 " -i $1`
fi
}

# function that create the necessary dirs:
function createDirectories {
find $1 -maxdepth 1 -type f -mtime +7 -printf "mkdir -p $2/%TY/%Tm/\n" | sh
}

function jerkData {
find $1 -maxdepth 1 -type f -mtime +7 -printf "mv %h/%f $2/%TY/%Tm/%f\n" | sh
}

function leaveSigniture {
log_file=$1/last_run.log
date_stamp=`date`
echo "Last run time: $date_stamp" > $log_file
}

function validateInput() {
if [ $1 ] && [ $2 ]; then
  return "1"
else
  printHelp
fi
}

function printHelp {
echo "$0 is expecting 2 arguments"
echo "Usage:"
echo "$0 {target} {destination}"
exit
}

logMsg "begin" 
validateInput $1 $2
SOURCE_OBJECT=$1
DESTINATION_OBJECT=$2

createDirectories $SOURCE_OBJECT $DESTINATION_OBJECT
jerkData $SOURCE_OBJECT $DESTINATION_OBJECT
leaveSigniture $DESTINATION_OBJECT

logMsg "end" 
