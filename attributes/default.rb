# Cookbook Name:: chef-splunk-forwarder
# Author:: Nikita Dinavahi
#
# This is a Chef attributes file. It can be used to specify default and override
# attributes to be applied to nodes that run this cookbook.

# Package uri for splunk-forwarder
case platform
  when "debian", "ubuntu"
    default["splunk"]["forwarder"]["package"]["url"] = "http://download.splunk.com/products/splunk/releases/6.4.0/universalforwarder/linux/splunkforwarder-6.4.0-f2c836328108-linux-2.6-amd64.deb"
  when "centos", "redhat", "amazon", "scientific"
    default["splunk"]["forwarder"]["package"]["url"] = "http://download.splunk.com/products/splunk/releases/6.4.0/universalforwarder/linux/splunkforwarder-6.4.0-f2c836328108-linux-2.6-x86_64.rpm"
end

# Splunk server details
default['splunk']['server_address'] = ['localhost:9997']
default['splunk']['monitor_folder'] = '/var/log/httpd'         # The directory that need to monitor
