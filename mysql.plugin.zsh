alias my='mysql'
alias mys='mysqlshow'
alias mya='mysqladmin'
alias mycu='mysql-create-user'
alias mycud='mysql-create-user-and-database'
alias mycd='mysql-create-db'
alias mytd='mysql-truncate-database'
alias mysu="mysql -e 'SELECT user, host FROM mysql.user'"

# Get password hash
mysql-password-hash() {
    PROGNAME=${0##*/}

    if [[ $# -eq 0 ]]; then
        echo "Usage: $PROGNAME plain_password"
        return 1
    fi

    mysql -e "SELECT PASSWORD('$1')" | grep '\*\w*'
}

# Create a new mysql user
mysql-create-user() {
    PROGNAME=${0##*/}

    if [[ $# -eq 0 ]]; then
        echo "Usage: $PROGNAME user_name [password]"
        return 1
    fi

    USER=$1
    if [[ $(echo $USER | grep -c '@') -eq 0 ]]; then
        USER="$USER@localhost"
    fi

    PASSWORD=$2
    if [[ -z $PASSWORD ]]; then
        echo -n "Enter user password: \n"; read -s PASSWORD
    fi

    PASSWORD_HASH=$(mysql-password-hash $PASSWORD)

    CREATE_USER_QUERY="CREATE USER \`${USER/@/\`@\`}\` IDENTIFIED BY PASSWORD '$PASSWORD_HASH'"

    mysql -e $CREATE_USER_QUERY
}

# Create a new mysql database
mysql-create-db() {
    PROGNAME=${0##*/}

    if [[ $# -eq 0 ]]; then
        echo "Usage: $PROGNAME database_name [user_name]"
        return 1
    fi

    DATABASE=$1
    USER=$2
    CHARACTER_SET=${CHARACTER_SET=utf8}
    COLLATION=${COLLATION=utf8_general_ci}

    CREATE_DATABASE_QUERY="CREATE DATABASE \`$DATABASE\` CHARACTER SET $CHARACTER_SET COLLATE $COLLATION"

    if [[ -n $USER ]]; then
        if [[ $(echo $USER | grep -c '@') -eq 0 ]]; then
            USER="$USER@localhost"
        fi
        CREATE_DATABASE_QUERY="$CREATE_DATABASE_QUERY; GRANT ALL PRIVILEGES ON \`$DATABASE\`.* TO \`${USER/@/\`@\`}\`"
    fi

    mysql -e $CREATE_DATABASE_QUERY
}

# Create a new user and database with the same name
mysql-create-user-and-database() {
    PROGNAME=${0##*/}

    if [[ $# -eq 0 ]]; then
        echo "Usage: $PROGNAME user_name [password]"
        return 1
    fi

    mysql-create-user $*
    mysql-create-db $1 $1
}

# Truncate all tables in a database
mysql-truncate-database() {
    PROGNAME=${0##*/}

    if [[ $# -eq 0 ]]; then
        echo "Usage: $PROGNAME database"
        return 1
    fi

    for table in $(mysql -Nse 'SHOW TABLES' $1); do
        mysql -e "TRUNCATE TABLE \`$table\`" $1
    done
}
