#
# Cookbook Name:: milmsearch
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create deploy user
data_ids = data_bag('users')
data_ids.each do |id|
  u = data_bag_item('users', id)
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
end

include_recipe "milmsearch::supervisor"

