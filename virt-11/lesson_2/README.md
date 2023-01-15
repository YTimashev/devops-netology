
# Домашнее задание к занятию "2. Применение принципов IaaC в работе с виртуальными машинами"

---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

## Задача 3

Установить на личный компьютер:

- VirtualBox
<pre><font color="#26A269"><b>tim@tim</b></font>:<font color="#12488B"><b>~</b></font>$ vboxmanage --version
6.1.38_Ubuntur153438
</pre>

- Vagrant
<pre><font color="#26A269"><b>tim@tim</b></font>:<font color="#12488B"><b>~</b></font>$ vagrant --version
Vagrant 2.2.19
</pre>

- Ansible
<pre><font color="#26A269"><b>tim@tim</b></font>:<font color="#12488B"><b>~/vagrant</b></font>$ ansible --version
ansible 2.10.8
  config file = /home/tim/vagrant/ansible.cfg
  configured module search path = [&apos;/home/tim/.ansible/plugins/modules&apos;, &apos;/usr/share/ansible/plugins/modules&apos;]
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.6 (main, Nov 14 2022, 16:10:14) [GCC 11.3.0]
</pre>

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*


## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
<pre><font color="#26A269"><b>tim@tim</b></font>:<font color="#12488B"><b>~/vagrant</b></font>$ vagrant up
Bringing machine &apos;server1.Net&apos; up with &apos;virtualbox&apos; provider...
<b>==&gt; server1.Net: Importing base box &apos;bento/ubuntu-20.04&apos;...</b>
<b>==&gt; server1.Net: Matching MAC address for NAT networking...</b>
<b>==&gt; server1.Net: Checking if box &apos;bento/ubuntu-20.04&apos; version &apos;202212.11.0&apos; is up to date...</b>
<b>==&gt; server1.Net: Setting the name of the VM: server1.Net</b>
<b>==&gt; server1.Net: Clearing any previously set network interfaces...</b>
<b>==&gt; server1.Net: Preparing network interfaces based on configuration...</b>
    server1.Net: Adapter 1: nat
    server1.Net: Adapter 2: hostonly
<b>==&gt; server1.Net: Forwarding ports...</b>
    server1.Net: 22 (guest) =&gt; 20011 (host) (adapter 1)
    server1.Net: 22 (guest) =&gt; 2222 (host) (adapter 1)
<b>==&gt; server1.Net: Running &apos;pre-boot&apos; VM customizations...</b>
<b>==&gt; server1.Net: Booting VM...</b>
<b>==&gt; server1.Net: Waiting for machine to boot. This may take a few minutes...</b>
    server1.Net: SSH address: 127.0.0.1:2222
    server1.Net: SSH username: vagrant
    server1.Net: SSH auth method: private key
    server1.Net: Warning: Connection reset. Retrying...
    server1.Net: Warning: Remote connection disconnect. Retrying...
    server1.Net: 
    server1.Net: Vagrant insecure key detected. Vagrant will automatically replace
    server1.Net: this with a newly generated keypair for better security.
    server1.Net: 
    server1.Net: Inserting generated public key within guest...
    server1.Net: Removing insecure key from the guest if it&apos;s present...
    server1.Net: Key inserted! Disconnecting and reconnecting using new SSH key...
<b>==&gt; server1.Net: Machine booted and ready!</b>
<b>==&gt; server1.Net: Checking for guest additions in VM...</b>
<b>==&gt; server1.Net: Setting hostname...</b>
<b>==&gt; server1.Net: Configuring and enabling network interfaces...</b>
<b>==&gt; server1.Net: Mounting shared folders...</b>
    server1.Net: /vagrant =&gt; /home/tim/vagrant
<b>==&gt; server1.Net: Running provisioner: ansible...</b>
    server1.Net: Running ansible-playbook...

PLAY [Playbook] ****************************************************************

TASK [Gathering Facts] *********************************************************
<font color="#26A269">ok: [server1.Net]</font>

TASK [Create directory for ssh-keys] *******************************************
<font color="#26A269">ok: [server1.Net]</font>

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
<font color="#A2734C">changed: [server1.Net]</font>

TASK [Checking DNS] ************************************************************
<font color="#A2734C">changed: [server1.Net]</font>

TASK [Installing tools] ********************************************************
<font color="#26A269">ok: [server1.Net] =&gt; (item=[&apos;git&apos;, &apos;curl&apos;])</font>

TASK [Installing docker] *******************************************************
<font color="#A2734C">changed: [server1.Net]</font>

TASK [Add the current user to docker group] ************************************
<font color="#A2734C">changed: [server1.Net]</font>

PLAY RECAP *********************************************************************
<font color="#A2734C">server1.Net</font>                : <font color="#26A269">ok=7   </font> <font color="#A2734C">changed=4   </font> unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

</pre>

- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды `docker ps`

<pre><font color="#26A269"><b>tim@tim</b></font>:<font color="#12488B"><b>~/vagrant</b></font>$ vagrant ssh
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun 15 Jan 2023 04:10:37 PM UTC

  System load:  0.09               Users logged in:          0
  Usage of /:   13.2% of 30.34GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 22%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    107


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sun Jan 15 16:05:07 2023 from 10.0.2.2
<font color="#26A269"><b>vagrant@server1</b></font>:<font color="#12488B"><b>~</b></font>$ 
</pre>

<pre><font color="#26A269"><b>vagrant@server1</b></font>:<font color="#12488B"><b>~</b></font>$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
<font color="#26A269"><b>vagrant@server1</b></font>:<font color="#12488B"><b>~</b></font>$ 
</pre>
