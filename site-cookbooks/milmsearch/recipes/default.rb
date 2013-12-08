#
# Cookbook Name:: milmsearch
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create deploy user
u = data_bag_item('users', 'milmsearch')
user u['username'] do
  home  u['home']
  group u['group']
  shell u['shell']
  password nil
  supports :manage_home => true
end

directory "#{u['home']}/.ssh" do
  owner u['username']
  group u['group']
  mode 0700
  action :create
  only_if "test -d #{u['home']}"
end

file "#{u['home']}/.ssh/authorized_keys" do
  owner u['username']
  group u['group']
  mode 0600
  action :create
  content u['key']
end  

include_recipe "milmsearch::supervisor"

# conf
conf_dir = "#{u['home']}/conf"
directory conf_dir do
  owner u['username']
  group u['group']
  mode 0700
  action :create
end

db = Chef::EncryptedDataBagItem.load("apps", "db", "data_bag_key/secret_key")
es = Chef::EncryptedDataBagItem.load("apps", "elasticsearch", "data_bag_key/secret_key")
template "/usr/local/milmsearch/conf/application-production.conf" do
  owner u['username']
  group u['group']
  mode 0600
  variables(
    :driver   => db['driver'],
    :url      => db['url'],
    :user     => db['user'],
    :password => db['password'],
    :hostName => es['hostName'],
    :port     => es['port']
  )
end

include_recipe "milmsearch::iptables"