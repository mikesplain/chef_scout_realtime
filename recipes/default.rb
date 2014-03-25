#
# Cookbook Name:: chef_scout_realtime
# Recipe::default
#
# Copyright 2013, Mike Splain
#

# Install Scout gem
if(Gem::Version.new(Chef::VERSION) < Gem::Version.new('0.10.9'))
  Chef::Log.debug 'Installing scout_realtime gem with trick method'
  # Method used is referenced here:
  # http://www.opscode.com/blog/2009/06/01/cool-chef-tricks-install-and-use-rubygems-in-a-chef-run/
  # TODO: Remove once 0.10.8 is fully end-of-life
  r = gem_package "scout_realtime" 
  r.run_action(:install)
  Gem.clear_paths
  require 'scout_realtime'
else
  # The chef_gem provider was introduced in Chef 0.10.10
  chef_gem "scout_realtime"
end

scout_realtime_bin = "#{Gem.bindir}/scout_realtime"
pid_path = "/var/run/scout_realtime.pid"

log "Scout bin: #{scout_realtime_bin}"

bash "start scout_realtime" do
  code <<-EOH
   #{scout_realtime_bin} start --pid-path #{pid_path}
   EOH
  only_if do File.exist?(scout_realtime_bin) && !File.exist?(pid_path) end
end