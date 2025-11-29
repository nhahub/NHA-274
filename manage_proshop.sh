#!/bin/bash

if [ "$1" == "cleanup" ]; then
  echo "Cleaning up ProShop stack..."
  ansible-playbook ansible/deploy.yml -e action=cleanup --ask-become-pass
else
  echo "Deploying ProShop stack..."
  ansible-playbook ansible/deploy.yml -e action=deploy --ask-become-pass
fi
