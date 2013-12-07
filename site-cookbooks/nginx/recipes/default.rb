#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::epel"

package "nginx" do
  action :install
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/nginx/conf.d/default.conf" do
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end

template "/etc/nginx/conf.d/ssl.conf" do
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end
