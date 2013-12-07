#
# Cookbook Name:: milmsearch-postgresql
# Recipe:: default
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
  user "milmsearch"
  command "psql -c \"alter role milmsearch with password '#{db['password']}'\""
  not_if "psql -U postgres -c \"select * from pg_shadow where usename='#{db['user']}' and passwd is not null\" | grep -q #{db['user']}", :user => "postgres"
end

execute "create-database" do
  user "postgres"
  command "createdb -O #{db['user']} #{db['user']}"
  not_if "psql -U postgres -c \"select * from pg_database WHERE datname='#{db['user']}'\" | grep -q #{db['user']}", :user => "postgres"
end

