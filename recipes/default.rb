
#
# Apache
#
include_recipe 'apt'
include_recipe 'apache2'

#
# Mod Rewrite
#
include_recipe 'apache2::mod_rewrite'


#
# Install Java
#
node.set['java']['install_flavor']             = 'openjdk'
node.set['java']['jdk_version']                = '7'

include_recipe "java"

#
# Elasticsearch
#
if node['ts_basebox']['elasticsearch']['install']
  node.set['elasticsearch']['version']            = '1.5.1'
  node.set['elasticsearch']['cluster']['name']    = 'ts'

  include_recipe "elasticsearch"
end

#
# Solr
#
if node['ts_basebox']['solr']['install']
  node.set['solr']['version']                   = '4.10.4'

  include_recipe "solr"
end

#
# MySQL
#
node.set['mysql']['server_debian_password']     = 'root'
node.set['mysql']['server_root_password']       = 'root'
node.set['mysql']['server_repl_password']       = 'root'

include_recipe 'mysql::server'
include_recipe 'mysql::client'

#
# Git
#
package "git"


#
# PHP
#
include_recipe 'apache2::mod_php5'

#
# Install php modules
#
package "php-pear"
package "php-apc"
package "php5-cgi"
package "php5-cli"
package "php5-common"
package "php5-curl"
package "php5-fpm"
package "php5-gd"
package "php5-imagick"
package "php5-imap"
package "php5-intl"
package "php5-mcrypt"
package "php5-memcache"
package "php5-ming"
package "php5-mysql"
package "php5-ps"
package "php5-pspell"
package "php5-readline"
package "php5-recode"

package "snmp"
package "php5-snmp"

package "php5-sqlite"
package "php5-tidy"
package "php5-xmlrpc"
package "php5-xsl"
package "php5-ldap"
package "php5-dev"

#
# Composer
#
include_recipe 'composer::install'
include_recipe 'composer::self_update'

execute "adding global bin path of composer to bash profile" do
  command 'export PATH=~/.composer/vendor/bin:$PATH'
end

execute "add composer bin to bashrc" do
  command "echo  'export PATH=~/.composer/vendor/bin:$PATH' >> ~/.bashrc"
end

execute "add composer bin to vagrant bashrc" do
  command "echo  'export PATH=/root/.composer/vendor/bin:$PATH' >> /home/vagrant/.bashrc"
end

#
# Install phpunit
#
execute "install phpunit" do
  command 'composer global require "phpunit/phpunit=4.6.*"'
end

#
# Install robo
#
execute "install robo" do
  command 'composer global require "codegyre/robo=0.5.2"'
end

#
# Fix composer permissions
#
bash "fix ownership" do
  cwd '/root/.composer'
  code 'chown www-data:vagrant -R .'
end

bash "fix permission" do
  cwd '/root'
  code 'chmod 775 -R .'
end

#
# Configure vim
#
template "/home/vagrant/.vimrc" do
  source ".vimrc.erb"
end

#
# Adjust php.ini
#
template "/etc/php5/cli/php.ini" do
  source "php.ini.cli.erb"
  cookbook "ts_basebox"
end

template "/etc/php5/apache2/php.ini" do
  source "php.ini.apache.erb"
  cookbook "ts_basebox"
end
