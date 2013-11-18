#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

repo_rpm_filename = "elasticsearch-0.90.3.noarch.rpm"

# Download elasticsearch RPM as a local file
remote_file "#{Chef::Config[:file_cache_path]}/#{repo_rpm_filename}" do
  source "https://download.elasticsearch.org/elasticsearch/elasticsearch/#{repo_rpm_filename}"
  not_if "rpm -q elasticsearch"
end

# Install elasticsearch RPM from the local file
package "elasticsearch" do
  provider Chef::Provider::Package::Rpm
  source "#{Chef::Config[:file_cache_path]}/#{repo_rpm_filename}"
end

service "elasticsearch" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

