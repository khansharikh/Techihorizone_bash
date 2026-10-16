#!/bin/bash
#owner = Sharikh khan
#modefied = 16th of oct. 2026

#1

echo "######### CHECK IF DIRECTORY IS AVAILABLE OR NOT #########"
echo
if [ -e /root/sharikh ]

then
	echo "directory exist"

else
	echo "directory does not exist"

fi
echo
echo

#2
echo  "######### CREATING MULTIPLE FILES ###########"
echo

touch /root/sharikh/{a,b,c,1,2,3,4,5}
echo
echo
echo "######### LIST THE FILES IN SHARIKH DIRECTORY ############"
echo
ls /root/sharikh
echo
echo

#3
echo "####### TAKE BACKUP OF DIRECTORY SHARIKH #########"
echo
cp -r /root/sharikh /root/scripts/sharikh_backup
echo 
ls /root/scripts
#4
echo "####################################### INSTALLING NGINX#######################################################"
echo
echo
yum install nginx -y > /dev/null

if  [ $? -eq 0 ]
then

echo "######################################### NGINX IS SUCCESFULLY INSTALLED ###############################################"
fi
echo
echo
echo "########################################## CHECK THE STATUS OF NGINX ######################################"
echo
echo
status=$(systemctl status nginx | grep inactive)
start=$(systemctl start nginx)
echo
echo $status

if [ $? -eq 0 ]
then
   $start
else
echo "##################################################nginx is unable to start##########################################"
fi
echo
echo $start
echo "################################################## NGINX IS STARTED ##############################################"


#5
echo "############################################ INSTALLING TOMCAT  ##############################################"
echo
yum update -y
yum install java -y

mkdir /root/server1
wget -P /root/server1 https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.61/bin/apache-tomcat-10.1.61.tar.gz
tar -xvzf /root/server1/apache-tomcat-10.1.61.tar.gz

echo
echo " ########STARTING TOMCAT SERVIS USING ./STARTUP.SH #################################"
/root/scripts/apache-tomcat-10.1.61/bin/startup.sh
if [ $? -eq 0 ]
then
	echo "################################### TOMCAT HAS STARTED ###############################"
echo 
else
	echo "################################## UNABLE TO START TOMCAT ##########################"
fi
echo
netstat -na | grep 8080

#6
echo "########################################## CHECK THE STATUS OF NGINX ######################################"
echo
echo
status=$(systemctl status nginx | grep inactive)
start=$(systemctl start nginx)
echo
echo $status

if [ $? -eq 0 ]
then
echo $start
else
echo "##################################################nginx is unable to start##########################################"
fi
echo $status

echo nginx is active


#7


echo "Enter first number:"
read a

echo "Enter second number:"
read b

echo "Addition: $((a + b))"
echo "Subtraction: $((a - b))"
echo "Multiplication: $((a * b))"
echo "Division: $((a / b))"


#8
echo
echo  "##################### CHECK IF DIRECTORY IS AVAILABLE IF NOT CREATE NEW ONE ########################################"
echo
DIR="/root/sharikh"

if [ -d "$DIR" ]; then
    echo "Directory already exists"
else
    mkdir -p "$DIR"
    echo "Directory created successfully"
fi

#9
read -p "Enter file name: " file

if [ -f "$file" ]; then
    sed -i '$d' "$file"
    sed -i '$d' "$file"
    sed -i '$d' "$file"

    echo "Last 3 lines deleted successfully"
else
    echo "Error: File does not exist"
fi

#10
echo "################################# monitor cpu and if it is more than 80% then send email ###############################"
echo
THRESHOLD=80
EMAIL="admin@example.com"

# Get CPU usage percentage
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))

echo "Current CPU Usage: ${CPU_USAGE}%"

# Check CPU usage
if [ "$CPU_USAGE" -gt "$THRESHOLD" ]; then
    echo "WARNING: CPU usage is above ${THRESHOLD}%!"

    MESSAGE="Alert: CPU usage is ${CPU_USAGE}% on $(hostname)"

    echo "$MESSAGE" | mail -s "High CPU Usage Alert" "$EMAIL"

    echo "Email notification sent."
else
    echo "CPU usage is normal."
fi

#11
echo "################################################### monitor disk space and if it is more than 80% then send email ##################################"

THRESHOLD=80
EMAIL="admin@example.com"


df -P -x tmpfs -x devtmpfs | awk 'NR>1 {print $1, $5, $6}' |
while read -r DEVICE USAGE MOUNTPOINT
do
    USAGE=${USAGE%\%}

    if [ "$USAGE" -gt "$THRESHOLD" ]; then

        echo "WARNING: Disk usage is above ${THRESHOLD}%!"
        echo "Device: $DEVICE"
        echo "Mount Point: $MOUNTPOINT"
        echo "Usage: ${USAGE}%"

        MESSAGE="Disk Alert on $(hostname):
Mount Point: $MOUNTPOINT
Device: $DEVICE
Disk Usage: ${USAGE}%
Threshold: ${THRESHOLD}%"

        echo "$MESSAGE" | mail -s "Disk Space Alert" "$EMAIL"

        echo "Email notification attempted."
        echo
    else
        echo "OK: $MOUNTPOINT usage is ${USAGE}%"
    fi
done

#12
echo ################################### monitor memory and if it is more than 80% then send email ########################
echo
THRESHOLD=80
EMAIL="admin@example.com"

echo "######## CHECKING MEMORY USAGE ########"

# Get total and available memory in MB
TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

# Calculate memory usage percentage
USED=$((TOTAL - AVAILABLE))
USAGE=$((USED * 100 / TOTAL))

echo "Total Memory: ${TOTAL} MB"
echo "Used Memory: ${USED} MB"
echo "Memory Usage: ${USAGE}%"

# Check memory usage
if [ "$USAGE" -gt "$THRESHOLD" ]; then

    echo "WARNING: Memory usage is above ${THRESHOLD}%!"

    MESSAGE="Memory Alert on $(hostname):
Memory Usage: ${USAGE}%
Total Memory: ${TOTAL} MB
Used Memory: ${USED} MB
Threshold: ${THRESHOLD}%"

    echo "$MESSAGE" | mail -s "High Memory Usage Alert" "$EMAIL"

    echo "Email notification attempted."

else
    echo "Memory usage is normal."
fi
