#!/bin/bash

# I use this script to give the needed roles to user accounts attending to the workshop.
# just put user's emails, one per line, into accounts.txt

set -eu

PROJECT_ID=workshop-k8s-xxxxxx

for account in $(cat accounts.txt); do
    echo "Setting roles to $account..."
    gcloud projects add-iam-policy-binding $PROJECT_ID --member user:$account --role 'roles/editor'
    gcloud projects add-iam-policy-binding $PROJECT_ID --member user:$account --role 'roles/resourcemanager.projectIamAdmin'
done
