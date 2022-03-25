#!/usr/bin/env bash

# Get the usernames and email addresses
kubectl get profiles --all-namespaces -o json | jq -c '.items[] | {Owner:(.spec.owner.name), Name:(.metadata.name)}' -r > kubectl-output.json
sed -i 's/"Owner"://g' kubectl-output.json
sed -i 's/"Name"://g' kubectl-output.json
sed -i 's/["]//g' kubectl-output.json
sed -i 's/[{}]//g' kubectl-output.json
mv kubectl-output.json kubectl-output.csv

# Get the First Name and Last Name...
kubectl get profiles --all-namespaces -o json | jq -c '.items[] | .spec.owner.name' -r |  awk -F"@" '{print $1}'| sed 's/\./\ /g' | sed 's/[^ ]\+/\L\u&/g' > names.txt

# Add Names
paste kubectl-output.csv names.txt | column -s, | uniq | sort > output.csv

# Can't understand how to stop the tabs
sed -i 's/\t/,/g' output.csv

# Add Column Titles
echo "Email Address, User Name, Name" > header.txt
cat header.txt output.csv > aaw-users.csv

# Clean up

rm kubectl-output.csv
rm names.txt
rm output.csv
rm header.txt
