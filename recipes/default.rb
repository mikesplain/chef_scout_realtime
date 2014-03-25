#
# Cookbook Name:: chef_scout_realtime
# Recipe::default
#
# Copyright 2013, Mike Splain
#

# Create Scout user

group node['scout_realtime']['group'] do
  gid node['scout_realtime']['gid']
  action [:create, :manage]
end
user node['scout_realtime']['user'] do
  comment "Scout Realtime Agent"
  gid node['scout_realtime']['group']
  home "/home/#{node['scout_realtime']['user']}"
  shell "/bin/bash"
  supports :manage_home => true
  action [:create, :manage]
end

# Install Scout gem
if(Gem::Version.new(Chef::VERSION) < Gem::Version.new('0.10.9'))
  Chef::Log.debug 'Installing scout_realtime gem with trick method'
  # Method used is referenced here:
  # http://www.opscode.com/blog/2009/06/01/cool-chef-tricks-install-and-use-rubygems-in-a-chef-run/
  # TODO: Remove once 0.10.8 is fully end-of-life
  r = gem_package "scout_realtime" do
    version node['scout_agent']['version']
    action :nothing
  end
  r.run_action(:install)
  Gem.clear_paths
  require 'scout_realtime'
else
  # The chef_gem provider was introduced in Chef 0.10.10
  chef_gem "scout_realtime"
end

scout_realtime_bin = "#{Gem.bindir}/scout_realtime"

log "Scout bin: #{scout_realtime_bin}"

bash "start scout_realtime" do
  user node['scout_realtime']['user']
  group node['scout_realtime']['group']
  cwd "/home/#{node['scout_realtime']['user']}"
  code <<-EOH
   /opt/chef/embedded/bin/ruby /opt/chef/embedded/bin/scout_realtime start
   EOH
  returns 1
  # only_if do File.exist?(scout_realtime_bin) end
end