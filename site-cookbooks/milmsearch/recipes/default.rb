#
# Cookbook Name:: milmsearch
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "milmsearch::supervisor"

user "milmsearch" do
  home "/usr/local/milmsearch"
  shell "/bin/bash"
  password nil
  supports :manage_home => true
end
