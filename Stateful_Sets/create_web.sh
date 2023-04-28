#!/bin/bash

echo "**********************************************"
echo "********** Copy WebServer Data ***************"
echo "**********************************************"

for ((i=0;i<=1;i++))
do
  echo "Creating content in files for webserver-$i"
  oc exec -it pod/webserver-"$i" -- /bin/bash -c 'echo "Hello from the stateful set - This is Webserver-'$i' and my hostname is ${HOSTNAME}" > /var/www/html/index.html'
  
  echo "Creating Service"
  oc expose pod webserver-"$i"

  echo "Creating Route"
  oc expose service webserver-"$i" 

done
