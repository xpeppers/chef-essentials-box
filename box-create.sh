#!/bin/bash -e

#vagrant up --provision

rm -f chef-essentials.box
vagrant push local
vagrant box add --force --name xpeppers/chef-essentials chef-essentials.box

export ATLAS_TOKEN=`cat ~/.vagrant.d/data/vagrant_login_token`
vagrant push remote
