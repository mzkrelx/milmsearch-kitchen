#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum"

unless ::File.exists?("/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93")
  cookbook_file "#{Chef::Config[:file_cache_path]}/RPM-GPG-KEY-PGDG-93" do
  end

  yum_key "RPM-GPG-KEY-PGDG-93" do
    url "file://#{Chef::Config[:file_cache_path]}/RPM-GPG-KEY-PGDG-93"
  end
end

yum_repository "postgresql" do
  description "PostgreSQL 9.3 $releasever - $basearch"
  key "RPM-GPG-KEY-PGDG-93"
  url "http://yum.postgresql.org/9.3/redhat/rhel-$releasever-$basearch"
end

package "postgresql93-server" do
  action :install
end

execute "/sbin/service postgresql-9.3 initdb --encoding=UTF8 --no-locale" do
  not_if { ::FileTest.exist?(File.join("/var/lib/pgsql/9.1/data", "PG_VERSION")) }
end

service "postgresql-9.3" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

