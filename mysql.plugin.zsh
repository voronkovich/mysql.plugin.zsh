alias my='mysql'
alias mys='mysqlshow'
alias mysd='mysqlshow'
alias mysu="mysql -e 'SELECT user, host FROM mysql.user'"
alias mya='mysqladmin'
alias mycu='mysql-create-user'
alias mydu='mysql-drop-user'
alias mycud='mysql-create-user-and-database'
alias mydud='mysql-drop-user-and-database'
alias mycd='mysql-create-database'
alias mydd='mysql-drop-database'
alias mytd='mysql-truncate-database'

fpath=("${0:A:h}/functions" $fpath)

autoload -U mysql-create-database
autoload -U mysql-create-user
autoload -U mysql-create-user-and-database
autoload -U mysql-drop-database
autoload -U mysql-drop-user
autoload -U mysql-drop-user-and-database
autoload -U mysql-truncate-database
