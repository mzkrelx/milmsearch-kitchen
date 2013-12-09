#
# Cookbook Name:: milmsearch
# Recipe:: postgresql
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "postgresql::server"

db = Chef::EncryptedDataBagItem.load("apps", "db", "data_bag_key/secret_key")

execute "create-user" do
  user "postgres"
  command "createuser -s #{db['user']} "
  not_if "psql -U postgres -c \"select * from pg_user where usename='#{db['user']}'\" | grep -q #{db['user']}", :user => "postgres"
end

execute "set-password" do
  user "postgres"
  command "psql -c \"alter role #{db['user']} with password '#{db['password']}'\""
  not_if "psql -U postgres -c \"select * from pg_shadow where usename='#{db['user']}' and passwd is not null\" | grep -q #{db['user']}", :user => "postgres"
end

# Create the database of the name same as the db user name.
execute "create-database" do
  user "postgres"
  command "createdb -O #{db['user']} #{db['user']}"
  not_if "psql -U postgres -c \"select * from pg_database WHERE datname='#{db['user']}'\" | grep -q #{db['user']}", :user => "postgres"
end

