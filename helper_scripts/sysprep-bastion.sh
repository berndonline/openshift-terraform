#!/usr/bin/env bash

sudo yum install -y "@Development Tools" python2-pip openssl-devel python-devel gcc libffi-devel

pip install -I ansible==2.4.3.0
git clone -b release-3.9 https://github.com/openshift/openshift-ansible

# pip install -Iv ansible==2.4.1.0
# git clone -b release-3.7 https://github.com/openshift/openshift-ansible

# Run playbook
# ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/prerequisites.yml
# ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/deploy_cluster.yml
