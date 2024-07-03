#A Unix User Management With Bash Script

##Introduction

Unix-likeoperating systems provide powerful tools for user and group management through command-line (CLI) interfaces. Automation of user management tasks using bash scripting enhances efficiency and ensures consistency.
This report explores a detailed bash script designed for managing users, groups, home directories, passwords,and secure logging on Unix systems.

#Script Overview
The bash is structured to read from an inmput formatted as `user;groups`. It performs several key tasks for each user specified in the input file supply as argument to the bash script:

1: Create a user if it does not exist using `useradd`
2: Create a personal group for the user as specified in the input file using `groupad`
3: Parse additional groups from the input file separated by `,`
4: Create any additional groups that do not exist using `groupadd`
5: Adds the user to all specified groups using `usermod`
6: Generate a random password using `pwgen`
7: Sets generated password for each user using `chpasswd`
8: Stores the username and password securely in /var/secure/user_passwords.txt
9:Create a home directory for each user under /home.
10: Sets ownership using `chown` and permissions using `chmod` for each home directory to ensure security and privacy
11: Logs all performs action into /var/log/user_management.log

##Script implementation

For each user and specified in  the input file

*: Check if the user exits already using `id`
*: Create the user if it doesn't 
*: Creates a personal group for the user as specified in the input line of the files
*: Adds the user to their perosnla groups and any additional groups separated by `,`
*: Generate Password (14-character) randomlly using `pwgen -s 14 1`
*: Sets thegenerated password for each user using `chpasswd`
*: Creates a homedirectory for each user under /home using `mkdir`
*: Sets ownership of the directoyr using `chown`
*: Sets permission using   `chmod 700`

#For practise more of this you can join us at [HNG INTERNSHIP](https://hng.tech/internship) or [HNG HIRE](https://hng.tech/hire)