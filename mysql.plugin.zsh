export ZSH_PLUGIN_MYSQL_PATH=$(dirname $(readlink -f $0))

alias my='mysql'
alias mycu="$ZSH_PLUGIN_MYSQL_PATH/mysql-create-user"
alias mycd="$ZSH_PLUGIN_MYSQL_PATH/mysql-create-db"
alias mysu="mysql -e 'SELECT user, host FROM mysql.user'"
alias mysd="mysql -e 'SHOW DATABASES'"
