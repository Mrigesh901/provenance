#! /bin/bash

#add user and set permisions
sudo useradd -m ${script_user}  # create a user, -m is passed to create a home directory for that user
sudo groupadd ${script_group} # create a group to add a user and give write persmissions 
sudo usermod -a -G  ${script_group} ${script_user} # add user to group
 
sudo chown -R ${script_user}:${script_group} ${PROVENANCE_DIR}
sudo chmod -R 764 ${PROVENANCE_DIR}
