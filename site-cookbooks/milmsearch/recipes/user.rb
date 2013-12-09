#
# Cookbook Name:: milmsearch
# Recipe:: user
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

u = data_bag_item('users', 'milmsearch')

group u['group'] do
  action :create
end

# Add deploy 
user u['username'] do
  home  u['home']
  group u['group']
  shell u['shell']
  password nil
  supports :manage_home => true
end

# Make .ssh directory
directory "#{u['home']}/.ssh" do
  owner u['username']
  group u['group']
  mode 0700
  action :create
  only_if "test -d #{u['home']}"
end

# Copy ssh public key
file "#{u['home']}/.ssh/authorized_keys" do
  owner u['username']
  group u['group']
  mode 0600
  action :create
  content u['key']
end  
