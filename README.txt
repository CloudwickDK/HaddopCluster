ssh -L 8080:172.16.x.x:8080 username@openstack.cloudwick.com
ssh -L 8080:172.16.5.116:8080 despoina@openstack.cloudwick.com

ssh-keygen -t rsa -f .ssh/movielense_id
ssh-copy-id -i .ssh/movielense_id root@172.16.5.81
first line generates the key
second line copies the key to .5.81 node

you need to repeate the same code to all the nodes.
then in order to communicate among the nodes you need to change

vi .ssh/config
with ………...

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

now you can communicate among the nodes using ambari, master1, master2, data1,data2

then you need to install the .sh file this code copies the .sh file

scp /Users/hemanth/Documents/Cloudwick/Installation\ /Preinstallations.sh hemanth@openstack.cloudwick.com:install.sh

sed -i -e 's/\r$//' install_prerequisites.sh

and this code will run the .sh
ssh ambari 'bash -s'<install.sh


# This file (/etc/hosts) contains internal IPs and desired hostnames for each node

# 10.2.1.213 ambari.cloudwick.com

# 10.2.1.217 master1.cloudwick.com


# 10.2.0.193 master2.cloudwick.com 

# 10.2.0.182 data1.cloudwick.com 

# 10.2.0.160 data2.cloudwick.com




10.2.1.213	172.16.5.113

10.2.1.217	172.16.5.114

10.2.0.193        172.16.0.189
10.2.0.182        172.16.0.199
10.2.0.160        172.16.3.4



Examples:

Host ambari
       Hostname ambari.cloudwick.com
       User root
       IdentityFile ~/.ssh/movielense_id
	   Port 22
	   
	  

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
	   
	
   
	   

ssh ambrri -> ssh -p <Port> -l <Username> <Hostname> -i <Identityfile>  ->  
ssh -p 22  -l root ambari .cloudwick.com -i ~/.ssh/movielense_id -> 
    
->   ssh -p 22  -l root  10.2.1.213 -i ~/.ssh/movielense_id

sys config 
tail -f ambari agent status

vim /etc/ambari-agent/conf/ambari-agent.ini
service ambari-agent restart
tail -250 /var/log/ambari-agent/ambari-agent.log | grep error
curl -u admin:admin -H 'X-Requested-By: ambari' -X DELETE http://ambari.cloudwick.com:8080/api/v1/clusters/despHadoop/services/AMBARI_METRICS
yum upgrade openssl

sql
select component_name,current_state,service_name from hostcomponentstate;


Steps:

Step1:
Install prerequisites on all nodes by running install_prerequisites.sh
Step 2:

Install 
ssh-copy-id -i ~/.ssh_id_rsa.pub username@remote_host
and to get the correct ambara.ini file


 ProxyCommand ssh -q -W %h:%p openstack    (reverse tunelling)
sed -i.old -e 's/hostname=localhost/hostname=ambari.cloudwick.com/' /etc/ambari-agent/conf/ambari-agent.ini