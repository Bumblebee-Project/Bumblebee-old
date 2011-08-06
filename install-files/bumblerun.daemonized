#!/bin/bash

# Optirun helper, performance profile.
# Still dirty with parameters

##### Wait for the server to be ready
echo "Starting Bumblebee server"
i=1
while  [ `ps aux |grep xorg.conf.nvidia |wc -l` -eq 1 ]; do
   sleep 1
   i=`expr $i + 1`
   if [ $i -gt 15 ]; then
      echo "Bumblebee server failed to start"
      exit 1
   fi 
done

echo "Arguments: $@"

trap "echo 'Caught Ctrl+C'" INT

# Try to send signal, permission issues...
# kill -STOP

vglrun "$@"

