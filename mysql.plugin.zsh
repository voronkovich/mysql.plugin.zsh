alias my='mysql'
alias mys='mysqlshow'
alias mya='mysqladmin'
alias mycu='mysql-create-user'
alias mycud='mysql-create-user-and-database'
alias mycd='mysql-create-database'
alias mytd='mysql-truncate-database'
alias mysu="mysql -e 'SELECT user, host FROM mysql.user'"

# Create a new mysql user
mysql-create-user() {
    local -r progname="${0##*/}"
    local help

    zmodload zsh/zutil
    zparseopts -D -F -K -- {h,-help}=help || return 1

    if [[ $# -eq 0 ]] || [[ -n "${help}" ]]; then
        echo -n "
Usage: ${progname} <user> [<password>]

Example:

  ${progname} bob qwerty123

  ${progname} alice@%
"
        return 0
    fi

    local user="${1}"
    if [[ ! "${user}" == *@* ]]; then
        user="${user}@localhost"
    fi

    local password="${2}"
    if [[ -z "${password}" ]]; then
        echo -n "Enter password:\n"
        read -s password
    fi

    command mysql -e "CREATE USER \`${user/@/\`@\`}\` IDENTIFIED BY '${password}'"
}

# Create a new mysql database
mysql-create-database() {
    local -r progname="${0##*/}"
    local help
    local -a charset=([2]='utf8')
    local -a collate=([2]='utf8_general_ci')

    zmodload zsh/zutil
    zparseopts -D -F -K -- \
        {h,-help}=help \
        -charset:=charset \
        -collate:=collate \
        || return 1

    if [[ $# -eq 0 ]] || [[ -n "${help}" ]]; then
        echo -n "
Usage: ${progname} <database> [<user>]

Options:

  --charset  Database character set [Default: utf8]
  --collate  Database collation [Default: utf8_general_ci]

Example:

  ${progname} app

  ${progname} --charset=latin1 --collate=latin1_swedish_ci app bob@%
"
        return 0
    fi

    local -r database="${1}"
    local user="${2}"

    local query="CREATE DATABASE \`${database}\` CHARACTER SET ${charset[2]#=} COLLATE ${collate[2]#=}"

    if [[ -n "${user}" ]]; then
        if [[ ! "${user}" == *@* ]]; then
            user="${user}@localhost"
        fi

        query+="; GRANT ALL PRIVILEGES ON \`${database}\`.* TO \`${user/@/\`@\`}\`"
    fi

    command mysql -e "${query}"
}

# Create a new user and database with the same name
mysql-create-user-and-database() {
    local -r progname="${0##*/}"
    local help
    local -a charset=([2]='utf8')
    local -a collate=([2]='utf8_general_ci')

    zmodload zsh/zutil
    zparseopts -D -F -K -- \
        {h,-help}=help \
        -charset:=charset \
        -collate:=collate \
        || return 1

    if [[ $# -eq 0 ]] || [[ -n "${help}" ]]; then
        echo -n "
Usage: ${progname} <user> [<password>]

Options:

  --charset  Database character set [Default: utf8]
  --collate  Database collation [Default: utf8_general_ci]

Example:

  ${progname} app

  ${progname} --charset=latin1 --collate=latin1_swedish_ci app bob@%
"
        return 0
    fi

    mysql-create-user "$@" \
        && mysql-create-database \
            --charset="${charset[2]#=}" \
            --collate="${collate[2]#=}" \
            "${1%@*}" "${1}"
}

# Truncate all tables in a database
mysql-truncate-database() {
    local -r progname="${0##*/}"
    local help

    zmodload zsh/zutil
    zparseopts -D -F -K -- {h,-help}=help || return 1

    if [[ $# -eq 0 ]] || [[ -n "${help}" ]]; then
        echo -n "
Usage: ${progname} <database>

Example:

  ${progname} my-blog
"
        return 0
    fi

    for table in $(mysql -Nse 'SHOW TABLES' "${1}"); do
        command mysql -e "TRUNCATE TABLE '${table}'" "${1}"
    done
}
