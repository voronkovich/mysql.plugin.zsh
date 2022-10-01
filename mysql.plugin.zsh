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
