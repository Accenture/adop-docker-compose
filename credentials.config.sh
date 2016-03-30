# Recursive function to check strength of user password
function checkPassword {

	# Check to disallow usage of Password01
	if [ "$1" == "Password01" ]; then
		echo "You are not allowed to use Password01! Please enter another password: "
		read -s PASSWORD
		checkPassword $PASSWORD
	fi

	# Check to ensure password is a minimum of 8 characters
	LEN=${#1}
	if [ $LEN -lt 8 ]; then
		echo "Your password length is $LEN. It must be at least 8. Try again: "
		read -s PASSWORD
		checkPassword $PASSWORD
	fi

	# Check to ensure password contains numerical characters
    if [[ $1 =~ [0-9] ]]; then
        echo
    else
        echo "Your password must contain a number. Try again: "
        read -s PASSWORD
		checkPassword $PASSWORD
    fi 
	
	echo "Your provided password satisfies the strength criteria."

}
function createPassword {
    date +%s | openssl sha256 | awk '{print $2}' | base64 | head -c 16; echo
}

###############################
if [ -z $ADMIN_USER ]; then
	echo "You have not provided a user name. Enter the initial admin user in the form <admin>.<user>: "
	read ADMIN_USER
	while [ "$ADMIN_USER" == "" ]; do
		echo "You have not entered a username. Try again..."
		read ADMIN_USER
	done
	export ADMIN_USER
else
	echo "Your user name is $ADMIN_USER"
fi

###############################
# Generate a random password if user leaves password flag blank 
# Else continue checking the input password
if [ -z $PASSWORD ]; then
 	echo "You have not provided a password. Generating random..."
 	export PASSWORD=$(createPassword)
 	echo "Your password is $PASSWORD"
	echo "**Please make note of this as you will use this password to log into all the tools**"
else
	checkPassword $PASSWORD
fi

# Store the password in base64 to be passed in as environment variable for docker-compose
export ADMIN_PWD=$(echo -n $PASSWORD | base64)

###############################
export PASSWORD_JENKINS=$(createPassword)
export JENKINS_PWD=$(echo -n $PASSWORD_JENKINS | base64)

###############################
export PASSWORD_GERRIT=$(createPassword)
export GERRIT_PWD=$(echo -n $PASSWORD_GERRIT | base64)

###############################
export PASSWORD_SQL=$(createPassword)
