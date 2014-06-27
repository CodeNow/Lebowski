#
# Cookbook Name:: runnable_lebowski
# Recipe:: deploy
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

require 'json'

package git

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
  notifies :deploy, "deploy[#{node['runnable_lebowski']['deploy']['deploy_path']}]", :delayed
  notifies :create, 'cookbook_file[/root/.ssh/runnable_lebowski.pub]', :immediately
end

cookbook_file '/root/.ssh/runnable_lebowski.pub' do
  source 'runnable_lebowski.pub'
  owner 'root'
  group 'root'
  mode 0600
  action :create
  notifies :deploy, "deploy[#{node['runnable_lebowski']['deploy']['deploy_path']}]", :delayed
end

file '/tmp/git_sshwrapper.sh' do
  content "#!/usr/bin/env bash\n/usr/bin/env ssh -o 'StrictHostKeyChecking=no' -i '/root/.ssh/runnable_lebowski' $1 $2\n"
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

deploy node['runnable_lebowski']['deploy']['deploy_path'] do
  repo 'git@github.com:CodeNow/Lebowski.git'
  git_ssh_wrapper '/tmp/git_sshwrapper.sh'
  branch 'master'
  deploy_to node['runnable_lebowski']['deploy']['deploy_path']
  migrate false
  create_dirs_before_symlink []
  purge_before_symlink []
  symlink_before_migrate({})
  symlinks({})
  action :deploy
  notifies :create, 'file[lebowski_config]', :immediately
  notifies :restart, 'service[lebowski]', :delayed 
end

file 'lebowski_config' do
  path "#{node['runnable_lebowski']['deploy']['deploy_path']}/current/configs/#{node.chef_environment}.json"
  content JSON.pretty_generate node['runnable_lebowski']['deploy']['config']
  action :nothing
  notifies :run, 'execute[npm install]', :immediately
  notifies :restart, 'service[lebowski]', :delayed 
end

execute 'npm install' do
  cwd "#{node['runnable_lebowski']['deploy']['deploy_path']}/current"
  action :nothing
  notifies :run, 'execute[npm run build]', :immediately
  notifies :restart, 'service[lebowski]', :delayed 
end

execute 'npm run build' do
  cwd "#{node['runnable_lebowski']['deploy']['deploy_path']}/current"
  action :nothing
  notifies :restart, 'service[lebowski]', :delayed 
end

service 'lebowski' do
  action :start
  stop_command 'pm2 stop Lebowski'
  start_command "bash -c 'NODE_ENV=#{node.chef_environment} pm2 start #{node['runnable_lebowski']['deploy']['deploy_path']}/current/server.js -n Lebowski'"
  status_command 'pm2 status | grep Lebowski | grep online'
  restart_command 'pm2 restart Lebowski'
  supports :start => true, :stop => true, :status => true, :restart => true
end
