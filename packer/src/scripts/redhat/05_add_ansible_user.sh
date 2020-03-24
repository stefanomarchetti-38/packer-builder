#!/bin/sh

useradd ansible

mkdir -p "/home/ansible/.ssh"

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQ7EQT9cD4JKDvXMutUDO17A1f2Yj4Bn2sXDFDPWkAeMCP3acevnJVL+CctqvP5TZRvSrONCwP12tOlBmwVv1kzpaWdkRy2se4NaYSYvOu1Y1mIhK0ghYQtgIyf8dRt1e1qFLiUfDF5l8aQziEc2I8kSZp8DVvjJMDJjdc9+lfKxZT+fKJfB5WD4ZtLCMrcxp7iIokVZzywkhqCtIJRh4nJ29PxNDigsDutKlaWDEZZPf+CM18zDvtTSKPruJzgJt7ihWQecFK/1l5xGFBjtGjo/DmkUmB5xUTrSRR6fCH+Z5bcmwnmsahAfQNAOhvov7X/Ua6bAnfE0kpUtKfOON1 ansible" > "/home/ansible/.ssh/authorized_keys"

chown -R ansible:ansible "/home/ansible/.ssh"

chmod 700 "/home/ansible/.ssh"

chmod 600 "/home/ansible/.ssh/authorized_keys"

echo "ansible ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/ansible_sudoer"

chown -R root:root "/etc/sudoers.d/ansible_sudoer"
