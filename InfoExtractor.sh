#!/bin/bash

#Loop input prompt till valid input is detected
while [[ $confirm != 'y' ]]; do 
	#Reading input for confirmation to run script
	read -p 'Do you allow this script to run? (y/n):' confirm 

	#Exit script if user does not allow script to run
	if [[ $confirm == 'n' ]]; then 
		echo 'Exiting'
		exit
		
	#Confirmation detected
	elif [[ $confirm == 'y' ]]; then 
		echo 'Running script...'
		
	#Prompting user that input was invalid		
	else 
		echo 'Invalid input!'

	fi
	
done

echo
echo 'Your public IP address is:'
#Calling ifconfig.io to return public IP address
curl -s ifconfig.io 

echo
echo 'Your internal IP address is:'
#Return internal IP address
hostname -I 

echo
echo 'Your device MAC address is:'
#Calling ifconfig to return device network details, and filtering and censoring results to return the censored MAC address 
ifconfig | grep ether | awk '{print $2}' | awk -F: '{print "XX:XX:XX:"$4":"$5":"$6""}' 

echo
echo 'The top 5 processes using highest amount of CPU are:'
#Calling ps to return CPU usage and process name, sorting results by CPU usage, filtering for the top 5 results
#and inputting them into a temp file
ps -eo %cpu,comm | sort -nr | head -5 > Temp
#printing results from temp file and numbering them
pr -tn Temp

echo
echo 'Here is the memory and swapfile statistics for your device:'
#Calling top and filtering for the memory and swapfile stats
top -b -n 1 | grep cache
top -b -n 1 | grep Swap

echo
echo 'Here is the list of all your active services:'
#Calling service to return the status of all services and filtering for the active services 
service --status-all | grep +

echo
echo 'Please enter user password to update directory database:'
#Updating directory database
sudo updatedb

echo
echo 'Here is the list of your top 10 largest files in the /home directory'
#Calling locate to return all files under /home, passing result through du to return file size, sorting and filtering for top 10 largest files, 
#and inputting results into temp file
locate /home | du * | sort -nr | head -10 > Temp
#printing results from temp file and numbering them
pr -tn Temp

#remove temp file
rm Temp
