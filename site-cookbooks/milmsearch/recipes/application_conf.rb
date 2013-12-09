#
# Cookbook Name:: milmsearch
# Recipe:: application_conf
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

u = data_bag_item('users', 'milmsearch')

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
