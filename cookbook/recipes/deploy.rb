#
# Cookbook Name:: runnable_api-server
# Recipe:: deploy
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

cookbook_file '/tmp/git_sshwrapper.sh' do
  source 'git_sshwrapper.sh'
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
  notifies :run, 'execute[npm install]', :immediately
end

execute 'npm install' do
  cwd "#{node['runnable_lebowski']['deploy']['deploy_path']}/current"
  action :nothing
  notifies :run, 'execute[npm run build]', :immediately
end

execute 'npm run build' do
  cwd "#{node['runnable_lebowski']['deploy']['deploy_path']}/current"
  action :nothing
  notifies :run, 'execute[smoke test]', :immediately
end

execute 'smoke test' do
  command 'npm test'
  cwd "#{node['runnable_lebowski']['deploy']['deploy_path']}/current"
  action :run
end 
