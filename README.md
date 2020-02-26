# docker.php.rpi.dev
Development php-fpm image for a rpi

Php-fpm 7.4.2 from alpine, with extensions enabled: 

- xdebug
- pdo_mysql
- zip
- intl
- xsl
- soap
- sockets
- bcmath
- sodium
- gd 

Includes composer, vim and git.

Global composer packages installed by default:

- infection/infection 
- friendsofphp/php-cs-fixer
- php-cs-fixer/phpunit-constraint-isidenticalstring 
- php-cs-fixer/phpunit-constraint-xmlmatchesxsd 
- phpstan/phpstan 
- phpstan/phpstan-symfony
- phpstan/phpstan-doctrine 
- behat/behat
- phpDocumentor


Ready to run symfony flex applications and magento2.

This is a personal toy, do not use this for anything unless you are willing to make it work for you.