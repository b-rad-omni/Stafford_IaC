#!/bin/bash

# setup_ansible.sh

# First, let's define our base directory
# We're using $PWD to get the current working directory
BASE_DIR="$PWD/ansible_base"

# Function to create a directory if it doesn't exist
create_directory() {
    echo "Creating directory: $1"
    mkdir -p "$1"
}

# Function to create a file with content
create_file() {
    local file_path="$1"
    local content="$2"
    echo "Creating file: $file_path"
    echo -e "$content" > "$file_path"
}

echo "Starting Ansible base setup..."

# 1. Create main directory structure
# These are all the directories we'll need for our Ansible setup
directories=(
    "$BASE_DIR/inventory/dev"
    "$BASE_DIR/inventory/staging"
    "$BASE_DIR/inventory/prod"
    "$BASE_DIR/group_vars/all"
    "$BASE_DIR/group_vars/webservers"
    "$BASE_DIR/host_vars"
    "$BASE_DIR/roles/common/tasks"
    "$BASE_DIR/roles/common/handlers"
    "$BASE_DIR/roles/common/templates"
    "$BASE_DIR/roles/common/files"
    "$BASE_DIR/roles/common/vars"
    "$BASE_DIR/roles/common/defaults"
    "$BASE_DIR/roles/common/meta"
    "$BASE_DIR/roles/docker/tasks"
    "$BASE_DIR/roles/security/tasks"
    "$BASE_DIR/roles/security/handlers"
    "$BASE_DIR/roles/monitoring/tasks"
    "$BASE_DIR/playbooks"
    "$BASE_DIR/collections"
    "$BASE_DIR/files"
    "$BASE_DIR/templates"
    "$BASE_DIR/vars"
)

# Create each directory
for dir in "${directories[@]}"; do
    create_directory "$dir"
done

# 2. Create ansible.cfg
echo "Creating ansible.cfg..."
create_file "$BASE_DIR/ansible.cfg" "[defaults]
inventory = inventory/
host_key_checking = False
forks = 5
roles_path = roles
interpreter_python = /usr/bin/python3
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts_cache
fact_caching_timeout = 7200

[ssh_connection]
pipelining = True"

# 3. Create inventory files
echo "Creating inventory files..."
# Development inventory
create_file "$BASE_DIR/inventory/dev/hosts" "[webservers]
dev-server ansible_host=your-dev-ip ansible_user=ubuntu

[all:vars]
environment=dev"

# Production inventory
create_file "$BASE_DIR/inventory/prod/hosts" "[webservers]
prod-server ansible_host=your-prod-ip ansible_user=ubuntu

[all:vars]
environment=prod"

# 4. Create group variables
echo "Creating group variables..."
create_file "$BASE_DIR/group_vars/all/common.yml" "---
# System settings
timezone: UTC
locale: en_US.UTF-8

# Common packages to install
common_packages:
  - vim
  - curl
  - git
  - htop
  - ufw
  - python3-pip

# SSH configuration
ssh_port: 22
ssh_permit_root_login: \"no\"
ssh_password_authentication: \"no\""

# 5. Create role files
echo "Creating role files..."

# Common role tasks
create_file "$BASE_DIR/roles/common/tasks/main.yml" "---
- name: Update apt cache
  apt:
    update_cache: yes
    cache_valid_time: 3600
  become: true

- name: Install common packages
  apt:
    name: \"{{ common_packages }}\"
    state: present
  become: true"

# Docker role tasks
create_file "$BASE_DIR/roles/docker/tasks/main.yml" "---
- name: Install Docker prerequisites
  apt:
    name:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg
      - lsb-release
    state: present
  become: true

- name: Install Docker
  apt:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-compose
    state: present
  become: true"

# Security role tasks
create_file "$BASE_DIR/roles/security/tasks/main.yml" "---
- name: Configure UFW
  ufw:
    rule: allow
    port: \"{{ item }}\"
    proto: tcp
  with_items:
    - \"{{ ssh_port }}\"
    - \"80\"
    - \"443\"
  become: true"

# 6. Create main playbook
echo "Creating main playbook..."
create_file "$BASE_DIR/playbooks/site.yml" "---
- name: Configure base system
  hosts: all
  roles:
    - common
    - security

- name: Configure web servers
  hosts: webservers
  roles:
    - docker
    - monitoring"

# 7. Create README
create_file "$BASE_DIR/README.md" "# Ansible Base Configuration

This directory contains the base Ansible configuration for managing our infrastructure.

## Directory Structure

- \`inventory/\`: Server inventory files
- \`group_vars/\`: Variables applied to groups of servers
- \`roles/\`: Reusable server configuration roles
- \`playbooks/\`: Ansible playbooks

## Usage

To run the playbook:

\`\`\`bash
# For development
ansible-playbook -i inventory/dev/hosts playbooks/site.yml

# For production
ansible-playbook -i inventory/prod/hosts playbooks/site.yml
\`\`\`"

# Set appropriate permissions
echo "Setting permissions..."
chmod 755 "$BASE_DIR/playbooks/site.yml"
chmod 600 "$BASE_DIR/ansible.cfg"

echo "Ansible base setup completed successfully!"
echo "Please review and modify the configurations as needed."
echo "Don't forget to update the inventory files with your actual server IPs."

# Instructions for next steps
echo "
Next steps:
1. Update inventory files with your actual server IPs
2. Review and customize group variables
3. Modify roles according to your specific needs
4. Test the setup with: ansible-playbook -i inventory/dev/hosts playbooks/site.yml --check"