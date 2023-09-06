#!/bin/bash

DATE=$(date +"%Y-%m-%d-%H")
KEY=/home/swenum/.ssh/otus2023.pub

yc compute instance create \
            --name reddit-app-full-$DATE \
            --hostname reddit-app-full-$DATE \
            --zone=ru-central1-a \
            --create-boot-disk size=15GB,image-id=fd8cbesgcg5s4i5co53r \
            --cores=2   --memory=8G   --core-fraction=100 \
            --network-interface subnet-id=e9b3fl1p2mptga02gee6,ipv4-address=auto,nat-ip-version=ipv4 \
            --ssh-key $KEY
