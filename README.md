# mysql.plugin.zsh

ZSH plugin for [MySQL](https://mysql.com).

## Installation

### [Antigen](https://github.com/zsh-users/antigen)

```sh
antigen bundle voronkovich/mysql.plugin.zsh
```
### [Zplug](https://github.com/zplug/zplug)

```sh
zplug "voronkovich/mysql.plugin.zsh"
```

### [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

```sh
git clone https://github.com/voronkovich/mysql.plugin.zsh ~/.oh-my-zsh/custom/plugins/mysql
```

Edit `.zshrc` to enable the plugin:

```sh
plugins=(... mysql)
```

### Manual

Clone this repo and add this into your `.zshrc`:

```sh
source path/to/cloned/repo/mysql.plugin.zsh
```

Add your mysql credentials into the ~/.my.cnf:
    
```
[client]
user=your_user
password=your_password
```

## Aliases and functions

+ my - alias for mysql;
+ mys - alias for mysqlshow;
+ mycu - create a new user;
+ mydu - drop a user;
+ mycd - create a new database;
+ mydd - drop a database;
+ mycud - create a new user and a database with the same name;
+ mydud - drop a user and a database with the same name;
+ mysu - show all users;
+ mytd - truncate all tables in the specified database;

## License

Copyright (c) Voronkovich Oleg. Distributed under the Unlicense.
