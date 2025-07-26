# Useful Scripts for Servers

## Setup

1. Copy setup script for server:

```sh
scp setup.sh root@<ip>:/root/
```

2. Allow script execution:

```sh
chmod +x setup.sh
```

3. And run:

```sh
./setup.sh
```

## About [K3s](https://github.com/k3s-io/k3s-ansible)

Just adapt `inventory.yml` to connect via SSH:
```yml
k3s_cluster:
  children:
    server:
      hosts:
        almalinux:
          ansible_host: <ip>
          ansible_user: ansible
          ansible_become: yes
          ansible_become_method: sudo
          ansible_become_user: root
          ansible_ssh_private_key_file: ~/.ssh/id_ansible
```

And then:

```sh
ansible-playbook playbooks/site.yml -i inventory.yml --ask-become-pass
```
