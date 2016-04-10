# Listing current partitions
fdisk -l /dev/vda

#Enter in fdisk shell for Partition Operation
fdisk /dev/vda

#After entering use below actions, in order
p #Prints current partition status
Command (m for help): p

[Sample Response]
Disk /dev/vda: 64 heads, 63 sectors, 621 cylinders
Units = cylinders of 4032 * 512 bytes
 
   Device Boot      Start         End      Blocks   Id  System
/dev/vda1   *        2048     1026047      512000   83  Linux
/dev/vda2         1026048   977588223   488281088   83  Linux


#New partition 
Command (m for help): n
[Sample Response]
Command action
   e   extended
   p   primary partition (1-4)

#Choose Primary
p 

 #Enter next partition number
Partition number (1-4): 4

# Enter first cylinder as the 'End' value of last partition from the current partitions
First cylinder (1-621, default 1): xxxx

# Go with Default to use all remaining space
Last cylinder or +size or +sizeM or +sizeK (1-621, default 621):

#To change FileSystem format of newly created partition
Command (m for help): t 

Partition number (1-4): 4

Hex code (type L to list codes): 83 #83 is ext4

#To print partition status
Command (m for help): p 
 
#Finally write changes
Command (m for help): w
CTRL+C/CTRL+D
-----------------------------------------------------------------------------------
vgs

#Creating Physical volume, If doesn't work, reboot and try again.
pvcreate VolGroup00 /dev/vda4
pvscan

#Extend Volume Group
vgextend VolGroup00 /dev/vda4 

#For 10 GB use 9.5G, similerly for 20 GB use 19.5G and so on.
lvextend -L+19.5G /dev/VolGroup00/LogVol00 
lvdisplay 

# Resize existing partition
resize2fs -p /dev/mapper/VolGroup00-LogVol00 
df -h