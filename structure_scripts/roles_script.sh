#!/bin/bash

# setup_roles.sh
# This script creates detailed configurations for each Ansible role
# Each role is a collection of tasks, handlers, and configurations that serve a specific purpose

# Exit on any error for safety
set -e

# Print commands before executing for better debugging
set -x

# Base directory for Ansible roles
BASE_DIR="ansible_base/roles"

# Function to create a file with content
create_file() {
    local file_path="$1"
    local content="$2"
    echo "$content" > "$file_path"
    echo "Created file: $file_path"
}

# 1. Common Role - Basic server setup
echo "Setting up Common Role..."

# Common Role - Main Tasks
create_file "$BASE_DIR/common/tasks/main.yml" "---
# Tasks for basic server setup

- name: Update package cache
  apt:
    update_cache: yes
    cache_valid_time: 3600
  when: ansible_os_family == 'Debian'
  tags: ['common', 'packages']

- name: Install essential packages
  apt:
    name:
      - vim
      - curl
      - git
      - htop
      - ntp
      - ufw
      - python3
      - python3-pip
      - fail2ban
    state: present
  when: ansible_os_family == 'Debian'
  tags: ['common', 'packages']

- name: Configure timezone
  timezone:
    name: '{{ timezone | default('UTC') }}'
  tags: ['common', 'timezone']

- name: Configure NTP
  template:
    src: ntp.conf.j2
    dest: /etc/ntp.conf
  notify: restart ntp
  tags: ['common', 'ntp']"

# Common Role - Handlers
create_file "$BASE_DIR/common/handlers/main.yml" "---
# Handlers for common role

- name: restart ntp
  service:
    name: ntp
    state: restarted

- name: reload ufw
  service:
    name: ufw
    state: reloaded"

# Common Role - Default Variables
create_file "$BASE_DIR/common/defaults/main.yml" "---
# Default variables for common role

timezone: UTC
ntp_servers:
  - 0.pool.ntp.org
  - 1.pool.ntp.org
  - 2.pool.ntp.org

# Package management
update_cache: yes
upgrade_packages: yes

# Security settings
ufw_default_incoming: deny
ufw_default_outgoing: allow"

# 2. Docker Role - Docker installation and configuration
echo "Setting up Docker Role..."

# Docker Role - Main Tasks
create_file "$BASE_DIR/docker/tasks/main.yml" "---
# Tasks for Docker installation and configuration

- name: Install Docker dependencies
  apt:
    name:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg
      - lsb-release
    state: present
  tags: ['docker', 'packages']

- name: Add Docker GPG key
  apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    state: present
  tags: ['docker', 'packages']

- name: Add Docker repository
  apt_repository:
    repo: 'deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable'
    state: present
  tags: ['docker', 'packages']

- name: Install Docker Engine
  apt:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    state: present
  notify: restart docker
  tags: ['docker', 'packages']

- name: Install Docker Compose
  get_url:
    url: 'https://github.com/docker/compose/releases/download/{{ docker_compose_version }}/docker-compose-Linux-x86_64'
    dest: /usr/local/bin/docker-compose
    mode: '0755'
  tags: ['docker', 'docker-compose']

- name: Create Docker group
  group:
    name: docker
    state: present
  tags: ['docker', 'configuration']

- name: Add users to Docker group
  user:
    name: '{{ item }}'
    groups: docker
    append: yes
  with_items: '{{ docker_users }}'
  tags: ['docker', 'configuration']"

# Docker Role - Handlers
create_file "$BASE_DIR/docker/handlers/main.yml" "---
# Handlers for Docker role

- name: restart docker
  service:
    name: docker
    state: restarted"

# Docker Role - Default Variables
create_file "$BASE_DIR/docker/defaults/main.yml" "---
# Default variables for Docker role

docker_compose_version: '2.21.0'
docker_users:
  - ubuntu

# Docker daemon configuration
docker_daemon_options:
  log-driver: 'json-file'
  log-opts:
    max-size: '100m'
    max-file: '3'"

# 3. Security Role - Server hardening
echo "Setting up Security Role..."

# Security Role - Main Tasks
create_file "$BASE_DIR/security/tasks/main.yml" "---
# Tasks for security hardening

- name: Configure SSH
  template:
    src: sshd_config.j2
    dest: /etc/ssh/sshd_config
  notify: restart ssh
  tags: ['security', 'ssh']

- name: Configure firewall rules
  ufw:
    rule: allow
    port: '{{ item }}'
    proto: tcp
  with_items:
    - '{{ ssh_port }}'
    - 80
    - 443
  tags: ['security', 'firewall']

- name: Enable UFW
  ufw:
    state: enabled
    policy: deny
  tags: ['security', 'firewall']

- name: Configure fail2ban
  template:
    src: jail.local.j2
    dest: /etc/fail2ban/jail.local
  notify: restart fail2ban
  tags: ['security', 'fail2ban']"

# Security Role - Handlers
create_file "$BASE_DIR/security/handlers/main.yml" "---
# Handlers for security role

- name: restart ssh
  service:
    name: ssh
    state: restarted

- name: restart fail2ban
  service:
    name: fail2ban
    state: restarted"

# Security Role - Default Variables
create_file "$BASE_DIR/security/defaults/main.yml" "---
# Default variables for security role

ssh_port: 22
ssh_permit_root_login: 'no'
ssh_password_authentication: 'no'

# fail2ban configuration
fail2ban_bantime: 600
fail2ban_findtime: 600
fail2ban_maxretry: 3"

# Set appropriate permissions
find "$BASE_DIR" -type d -exec chmod 755 {} \;
find "$BASE_DIR" -type f -exec chmod 644 {} \;
chmod +x "$0"

echo "Ansible roles setup complete!"
echo "Next steps:"
echo "1. Review the created role configurations"
echo "2. Customize variables in defaults/main.yml files"
echo "3. Add any additional tasks specific to your needs"
echo "4. Test roles individually using ansible-playbook"