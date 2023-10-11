#!/usr/bin/bash
#
# Travis Michette <tmichett@redhat.com>
#

read -p 'Please enter a valid OpenShift Username: ' username
read -p 'Please enter a valid OpenShift Password: ' password
read -p 'Please enter the API Address (ex. https://api.ocp4.example.com:6443): ' api_url


echo "export USERNAME=$username" > ~/ocp_creds.env
echo "export PASSWORD=$password" >> ~/ocp_creds.env
echo "export API=$api_url"  >> ~/ocp_creds.env
