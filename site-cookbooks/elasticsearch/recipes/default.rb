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
elasticsearch_dir = "/usr/share/elasticsearch"
kuromoji_path = "elasticsearch/elasticsearch-analysis-kuromoji/1.5.0"

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

# Make elasticsearch templates directory
directory '/etc/elasticsearch/templates' do owner 'root'
  group 'root'
  mode '0755 '
action :create end

# Set elasticsearch template file
cookbook_file "/etc/elasticsearch/templates/template_all.json" do
  source "templates/template_all.json"
  mode 00644
end

service "elasticsearch" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

execute "install kuromoji" do
  command "#{elasticsearch_dir}/bin/plugin -install #{kuromoji_path}"
  creates "#{elasticsearch_dir}/plugins/analysis-kuromoji"
end

template "/etc/elasticsearch/elasticsearch.yml" do
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[elasticsearch]"
end

# Set elasticsearch template
execute "Set template" do
  command "curl -XPUT http://localhost:9200/milmsearch/ -d \"\`cat /etc/elasticsearch/templates/template_all.json\`\""
end

