#
# Cookbook Name:: runnable_lebowski
# Recipe:: deploy_ssh
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode 0700
  action :create
  notifies :create, 'cookbook_file[/root/.ssh/runnable_lebowski]', :immediately
end

cookbook_file '/root/.ssh/runnable_lebowski' do
  source 'runnable_lebowski.key'
  owner 'root'
  group 'root'
  mode 0600
  action :create
  notifies :deploy, "deploy[#{node['runnable_lebowski']['deploy_path']}]", :delayed
  notifies :create, 'cookbook_file[/root/.ssh/runnable_lebowski.pub]', :immediately
end

cookbook_file '/root/.ssh/runnable_lebowski.pub' do
  source 'runnable_lebowski.pub'
  owner 'root'
  group 'root'
  mode 0600
  action :create
  notifies :deploy, "deploy[#{node['runnable_lebowski']['deploy_path']}]", :delayed
end

file '/tmp/git_sshwrapper.sh' do
  content "#!/usr/bin/env bash\n/usr/bin/env ssh -o 'StrictHostKeyChecking=no' -i '/root/.ssh/runnable_lebowski' $1 $2\n"
  owner 'root'
  group 'root'
  mode 0755
  action :create
end
