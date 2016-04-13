
# This file (/etc/hosts) contains internal IPs and desired hostnames for each node

# 10.2.1.213 ambari.cloudwick.com

# 10.2.1.217 master1.cloudwick.com

# 10.2.1.79 master2.cloudwick.com
# 10.2.0.193  data1.cloudwick.com
# 10.2.0.182  
data2.cloudwick.com
# 10.2.0.160 data3.cloudwick.com




Servers:

10.2.1.213	172.16.5.113

10.2.1.217	172.16.5.114
10.2.1.79	172.16.0.133
10.2.0.193      172.16.0.189
10.2.0.182      172.16.0.199
10.2.0.160      172.16.3.4


What does ss ambari do?	   


ssh ambari -> ssh -p <Port> -l <Username> <Hostname> -i <Identityfile>  ->  
ssh -p 22  -l root ambari .cloudwick.com -i ~/.ssh/movielense_id -> 
    
->   ssh -p 22  -l root  10.2.1.213 -i ~/.ssh/movielense_id

Delete AMBARI_METRICS for reinstallation because it didn't work:

curl -u admin:admin -H 'X-Requested-By: ambari' -X DELETE http://ambari.cloudwick.com:8080/api/v1/clusters/despHadoop/services/AMBARI_METRICS 
yum upgrade openssl

View amabri database components:

ssh ambari
myssql -u root -pdespsql
use ambari;
select component_name,current_state,service_name from hostcomponentstate;


Reverse tunelling:
ProxyCommand ssh -q -W %h:%p openstack    

///////////////////////////////////////////////////////////////////

Steps

Step1:

ssh openstack@despoina.cloudwick.com
ssh-keygen -t rsa -f .ssh/movielense_id
ssh-copy-id -i .ssh/movielense_id root@172.16.5.81         (ssh-copy-id -i ~/.ssh_id_rsa.pub username@remote_host)
first line generates the key
second line copies the key to .5.81 node

you need to repeate the same code to all the nodes.

Step 2:

then in order to communicate among the nodes you need to change

vi .ssh/config

Host ambari
       Hostname 172.16.5.80
       User root
       IdentityFile ~/.ssh/movielense_id
Host master1
       Hostname 172.16.5.81
       User root
       IdentityFile ~/.ssh/movielense_id
Host master2
       Hostname 172.16.5.82
       User root
       IdentityFile ~/.ssh/movielense_id
Host data1
       Hostname 172.16.5.83
       User root
       IdentityFile ~/.ssh/movielense_id
Host data2
       Hostname 172.16.5.95
       User root
       IdentityFile ~/.ssh/movielense_id

now you can communicate among the nodes using ssh ambari, master1, master2, data1,data2


Step 3:

Install the install_prerequisites.sh file 
this code copies the .sh file to a server

scp /Users/hemanth/Documents/Cloudwick/Installation/Preinstallations.sh despoina@openstack.cloudwick.com:install.sh

#remove end of line by replacing it with space
sed -i -e 's/\r$//' install_prerequisites.sh

Step 4:

Install prerequisites on all nodes by running:

ssh ambari 'bash -s'<install.shinstall_prerequisites.sh

Step 5:
run versions.sh to all nodes

Step 6:

install mysql server, 
create databases: one for oozie, one for hive, one for ambari
install ambari server on master node  (in our case ambari node)

Step 7:

In order to make the ambari agents communicate with ambari server: 

edit /etc/sysconfig/network and add the line HOSTNAME=<whatever.your.hostname.is> for that specific machine

and run the command
hostname <whatever.your.hostname.is> on the machine to set it immediately

(Alternative way: get the correct ambari.ini file:
sed -i.old -e 's/hostname=localhost/hostname=ambari.cloudwick.com/' /etc/ambari-agent/conf/ambari-agent.ini )

Step 8:

check if ambari agents respond on each node with the following commands:

-vim /etc/ambari-agent/conf/ambari-agent.ini
-service ambari-agent restart
-tail -250 /var/log/ambari-agent/ambari-agent.log | grep error

Step 9:

Run this and open your browser to: http://localhost:8080/#/main/services/HDFS/summary
ssh -L 8080:172.16.5.116:8080 despoina@openstack.cloudwick.com

