#
# Cookbook Name:: java
# Recipe:: default
#

bash "apt-get-update" do
	code "apt-get update"
end

package "openjdk-7-jdk" do
	action :install
end

#package "maven2"
