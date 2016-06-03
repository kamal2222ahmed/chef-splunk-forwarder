#
# Cookbook Name:: chef-splunk-forwarder
# Recipe:: forwarder
# Author:: Nikita Dinavahi
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'uri'

splunk_forwarder_uri = URI.parse(node['splunk']['forwarder']['package']['url'])
splunk_forwarder = File.join("/tmp", File.basename(splunk_forwarder_uri.path))
puts splunk_forwarder

# Download remote splunk packages
remote_file splunk_forwarder do
  action :create
  mode "0644"
  source splunk_forwarder_uri.to_s
end

# Install splunk forwarder
package "splunk-forwarder" do
  source splunk_forwarder
  provider case File.extname(splunk_forwarder)
            when ".deb"
              Chef::Provider::Package::Dpkg
            when ".rpm"
              Chef::Provider::Package::Rpm
            else
              Chef::Provider::Package
            end
  notifies :run, 'execute[enable-boot]', :delayed
end

# add web.conf
template '/opt/splunkforwarder/etc/system/local/web.conf' do
  source 'web.conf.erb'
  notifies :run, 'execute[splunk-forwarder-start]', :immediately
end

# forwarder input.conf
template '/opt/splunkforwarder/etc/system/local/inputs.conf' do
  source 'input.conf.erb'
  notifies :run, 'execute[splunk-forwarder-start]', :immediately
end

# forwarder outputs.conf
template '/opt/splunkforwarder/etc/system/local/outputs.conf' do
  source 'output.conf.erb'
  variables :splunk_servers => node['splunk']['server_address']
  notifies :run, 'execute[splunk-forwarder-start]', :immediately
end

# Manage splunk forwarder service
execute 'splunk-forwarder-start' do
  command "/opt/splunkforwarder/bin/splunk restart --accept-license --answer-yes"
  action :nothing
end

# Enable boot-start/init script
execute 'enable-boot' do
  command "/opt/splunkforwarder/bin/splunk enable boot-start"
  action :nothing
end
