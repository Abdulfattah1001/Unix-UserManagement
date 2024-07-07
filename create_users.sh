#! /bin/bash

#Test if the script is run with a file
if [ $# -ne 1 ]; then
	echo "Error Occurred: Usage : $0 <input_file>"
	#if not exit the script
	exit 1
fi

#global variable to hold the path to the log file
LOG_FILE="/var/log/user_management.log"

#function to log messages
log_message(){
	local log_content="$1"
	echo "$(date '+%Y-%m-%d %H:%M:$S') - ${log_content}" | sudo tee -a "$LOG_FILE"
}


#A function to generate a random password for a user
generate_pssd(){
	#pwgen -s 14 1
	openssl rand -base64 12
}

input_file=$1

#Main code starts here .CODE
while IFS=';' read -r user group;
		do
			#Check wethear the user and the group was specified in the file line
			if [ -n "$user" ] && [ -n "$group" ]
				then echo "Processing -> $user $group"

				#Check if the group is existing alredy, if not create it
				if ! getent group "$group" >/dev/null
					then log_message "Creating Group $group"
						sudo groupadd "$group"
						log_message "Group created succesfully $group"
				else
					log_message "Group already exist"
				fi

				#Check if the user is not existing before
				if ! id "$user" >/dev/null 2>&1
					then
						log_message "Creating user $user"
						#add the user to the specified group
						#sudo usermod -a -G "$group" "$user"
						#creating the user personal group or primary group
						sudo useradd -m -G "$user" "$user"
						sudo useradd -m -G "$group" "$user"
						log_message "user group created and added successfully $user"
						#handling additional groups for the user if the lines contains multiple groups (a,b,c)
						IFS=',' read -ra additional_groups <<< "$group"
						for group in "${additional_groups[@]}"
							do
								if ! getent group "$group" >/dev/null
									then sudo groupadd "$group"
									log_message "Created group successfully"
									sudo usermod -a -G"$group" "$user"
								fi
								done

						#set password for the user
						password=$(generate_pssd)
						sudo echo "$user:$password" | sudo chpasswd
						log_message "set password for user:$user"

						echo "$user:$password" | sudo tee -a /var/secure/user_passwords.txt

						log_message "Password stored for user $user successfully"

						#Creating the home directory for the user in question
						home_dir="/home/$user"
						sudo mkdir -p "$home_dir"
						sudo chown "$user:$user" "$home_dir"
						#Changing the user permission
						sudo chmod 700 "$home_dir"
						log_message "Home directory created successfully for user $user"
				else
					log_message "User already exit"
				fi
			else
				#
				log_message "Skipping line: '$user;$group'.Invalid format"
				continue

			fi
done < "$input_file"

#End of code
log_message "User and group management completed Succesfully"