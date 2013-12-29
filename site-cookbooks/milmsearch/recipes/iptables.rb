#
# Cookbook Name:: milmsearch
# Recipe:: iptables
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/sysconfig/iptables" do
  source "#{node['iptables']['templates']}"  
  owner "root"
  group "root"
  mode 0600
end

execute "iptables-restore" do
  user "root"
  command "iptables-restore < /etc/sysconfig/iptables"
end