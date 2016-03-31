# Recursive function to check strength of user password
function checkPassword {

	# Check to disallow usage of the word password
	if [[ "$1" = *"Password"* ]] || [[ "$1" = *"password"* ]]; then
		echo "You are not allowed to use a password containing the word password! Please enter another password: "
		read -s INITIAL_ADMIN_PASSWORD_PLAIN
		checkPassword $INITIAL_ADMIN_PASSWORD_PLAIN
	fi
	
	# Check to ensure username is not part of password
	if [[ "$1" = *$INITIAL_ADMIN_USER* ]]; then
		echo "You are not allowed to include your username in your password! Please enter another password: "
		read -s INITIAL_ADMIN_PASSWORD_PLAIN
		checkPassword $INITIAL_ADMIN_PASSWORD_PLAIN
	fi

	# Check to ensure password is a minimum of 8 characters
	LEN=${#1}
	if [ $LEN -lt 8 ]; then
		echo "Your password length is $LEN. It must be at least 8. Try again: "
		read -s INITIAL_ADMIN_PASSWORD_PLAIN
		checkPassword $INITIAL_ADMIN_PASSWORD_PLAIN
	fi

	# Check to ensure password contains numerical characters
    if [[ $1 =~ [0-9] ]]; then
        echo
    else
        echo "Your password must contain a number. Try again: "
        read -s INITIAL_ADMIN_PASSWORD_PLAIN
		checkPassword $INITIAL_ADMIN_PASSWORD_PLAIN
    fi 
	
	echo "Your provided password satisfies the strength criteria."

}

# Function to randomly generate a 16-character password with letters and numbers
function createPassword {
	sleep 1
	echo "$(date +%s%N | openssl sha256 | awk '{print $2}' | head -c 12)$[ 1000 + $[ RANDOM % 9999 ]]"
}


###############################
if [ -f ./platform.secrets.sh ]; then
	echo "Your secrets file already exists, moving on..."
else
	echo "Creating a new secrets file..."
	cp ./platform.secrets.sh.example ./platform.secrets.sh
	
	# Check for username, prompt one if not entered and write it to secrets file
	if [ -z $INITIAL_ADMIN_USER ]; then
		echo "You have not provided a user name. Please enter a username: "
		read INITIAL_ADMIN_USER
		while [ "$INITIAL_ADMIN_USER" == "" ]; do
			echo "You have not entered a username. Try again..."
			read INITIAL_ADMIN_USER
		done
		export INITIAL_ADMIN_USER
	else
		echo "Your user name is $INITIAL_ADMIN_USER"
	fi
	sed -i "s/###INITIAL_ADMIN_USER###/$INITIAL_ADMIN_USER/g" platform.secrets.sh

	# Generate a random password if user leaves password flag blank 
    # Else continue checking the input password
	if [ -z $INITIAL_ADMIN_PASSWORD_PLAIN ]; then
		echo "You have not provided a password. Generating random..."
		export INITIAL_ADMIN_PASSWORD_PLAIN=$(createPassword)
		echo "Your password is $INITIAL_ADMIN_PASSWORD_PLAIN"
		echo "**Please make note of this as you will use this password to log into all the tools**"
	else
		checkPassword $INITIAL_ADMIN_PASSWORD_PLAIN
	fi
	sed -i "s/###INITIAL_ADMIN_PASSWORD_PLAIN###/$INITIAL_ADMIN_PASSWORD_PLAIN/g" platform.secrets.sh
		
	# Generate random passwords for Jenkins, Gerrit and SQL and place them in secrets file
	echo "Generating random passwords for Jenkins, Gerrit and SQL..."
	PASSWORD_JENKINS=$(createPassword)
	sed -i "s/###PASSWORD_JENKINS_PLAIN###/$PASSWORD_JENKINS/g" platform.secrets.sh
	
	PASSWORD_GERRIT=$(createPassword)
	sed -i "s/###PASSWORD_GERRIT_PLAIN###/$PASSWORD_GERRIT/g" platform.secrets.sh
	
	PASSWORD_SQL=$(createPassword)
	sed -i "s/###PASSWORD_SQL_PLAIN###/$PASSWORD_SQL/g" platform.secrets.sh
fi

# Source all the variables that were written to the secrets file
echo "Sourcing variables from platform.secrets.sh file..."
source platform.secrets.sh

# Check to make sure the default tokens are not being used
if  [ $INITIAL_ADMIN_PASSWORD_PLAIN == "###INITIAL_ADMIN_PASSWORD_PLAIN###" ] || \
	[ $PASSWORD_JENKINS == "###PASSWORD_JENKINS_PLAIN###" ] || \
	[ $PASSWORD_GERRIT == "###PASSWORD_GERRIT_PLAIN###" ] || \
	[ $PASSWORD_SQL == "###PASSWORD_SQL_PLAIN###" ]; then
	echo "Your passwords are set to the default tokens provided in the example secrets file, this is not allowed."
	echo "Delete the platform.secrets.sh file and re-run the credentials.generate.sh script"
	exit
fi

# Export the passwords in base64 to be passed in as environment variable for LDAP container
export INITIAL_ADMIN_PASSWORD=$(echo -n $INITIAL_ADMIN_PASSWORD_PLAIN | base64)
export JENKINS_PWD=$(echo -n $PASSWORD_JENKINS | base64)
export GERRIT_PWD=$(echo -n $PASSWORD_GERRIT | base64)
