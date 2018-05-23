#!/bin/bash

yum install epel-release -y
yum install ansible -y


echo -e "\e[32m

1. Make below entry in /etc/ansible/hosts on client machine(Ansible Tower)

[servers]
server01 ansible_ssh_host=172.31.30.44

Note: Replace IP Address with your server machine private IP


2. Login to server machine and open '/etc/ssh/sshd_config' and change 'PasswordAuthentication no' to 'PasswordAuthentication yes'

3. Execute 'systemctl restart sshd' on server machine

4. Execute 'useradd ansible' on server machine

5. Execute 'visudo' on server machine and add 'ansible ALL=(ALL)       NOPASSWD:ALL' in last line.

6. Execute 'useradd ansible' on client machine.

7. Execute 'su - ansible' then 'ssh-keygen'  on client machine, press blank enter until you get shell prompt.

8. Execute 'passwd ansible' on both client and server and set password 'ansible'.

9. Execute  'ssh-copy-id ansible@172.31.30.44' on your client machine. Replace IP with your server private IP address. Enter password 'ansible' (step 8).

10. Execute  'ansible all -m ping' and 'ansible -m shell -a 'free -m' server01' and 'ansible -m ping server01' on your client machine.

10. Now create a file 'vim nginx_install.yml' and copy contents below


---
- hosts: server01
  tasks:
    - name: Installs nginx web server
      yum: pkg=nginx state=installed update_cache=true
      become: yes
      become_method: sudo
      become_user: root
      notify:
       - start nginx

  handlers:
    - name: start nginx
      service: name=nginx state=started
      become: yes
      become_method: sudo
      become_user: root


11. And your first playbook 'ansible-playbook nginx_install.yml' on client machine.

12. Now go to server machine and see process is running or not 'ps -ef | grep nginx'.

13. If the process is running hit your IP address in brower and see nginx default page 'http://YourServerIP'.

14. Create another yaml to start Nginx service in client machine(Ansible Tower) 'vim nginx_start.yml'. Jump to (step 16) if process Nginx is already running.

---
- hosts: server01
  tasks:
    - name: Start NGiNX
      service: name=nginx state=started
      name: nginx
      state: started
      become: yes
      become_method: sudo
      become_user: root

15. Now execute if the Nginx service is not running 'ansible-playbook nginx_start.yml'

16. Create another yaml to create a user, install package, create a file 'vim user_create.yml'.

---
- hosts: server01
  tasks:
      - name: Create file
        file:
            path: /tmp/etlhive.txt
            state: touch

- hosts: server01
  become_user: sudo
  tasks:
      - name: Create user
        user:
            name: etlhive
            shell: /sbin/nologin

      - name: Install zlib
        yum:
            name: zlib
            state: latest


17. And execute 'ansible-playbook user_create.yml'. Use 'ansible-playbook -vvv user_create.yml' to execute in debug mode.

16. That's it.

\e[0m\n"
