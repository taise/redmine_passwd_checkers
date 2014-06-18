# redmine_passwd_checker

This plugin is checking the password expiration.  
The password expiration limit is 3 months.

### install

Clone into the plugins directory.

```
$ cd /path/to/your/redmine
$ git clone git@github.com:taise/redmine_passwd_checker.git plugins
$ bundle install
$ bundle exec rake redmine:plugins:migrate
```

### test

```
$ cd /path/to/your/redmine
$ bundle install
$ bundle exec rails generate rspec:install
$ bundle exec rake redmine:plugins:migrate
$ bundle exec rspec plugin/redmine_passwd_checker/spec
```

