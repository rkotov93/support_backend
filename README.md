REQUIREMENTS
--
* ruby 2.3.1
* MySql 5.7.15


DATABASE PREPARATION
--

**Create DB user:**

* Login to mysql console with your super user using next command

  `mysql -u *super_user_name* -p`
* Then create database user with following commands

  ```SQL
  CREATE USER 'support_backend_user'@'localhost' IDENTIFIED BY 'support_backend_password';
  GRANT ALL PRIVILEGES ON support_backend_development.* TO 'support_backend_user'@'localhost';
  GRANT ALL PRIVILEGES ON support_backend_test.* TO 'support_backend_user'@'localhost';
  ```
  
BOOTSTRAPPING
--

**Do the following steps**
* bundle
* rake db:create
* rake db:migrate
* rake db:seed
* rails s
