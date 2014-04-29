#
# Cookbook Name:: cdh
# Recipe:: default
#

template "cloudera.list" do
	path "/etc/apt/sources.list.d/cloudera.list"
	source "cloudera.list.erb"
	owner "root"
	group "root"
	mode 00744
end

bash "apt-get-update" do
	code "apt-get update"
end

bash "add-cdh-repository" do
	code "curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | apt-key add -"
end

package 'hadoop-client' do
	options "-f --force-yes"
	action :install
end

bash "node format" do
	not_if { File.exists?("/usr/namenodeinstalled")}
	code <<-EOS
	sudo -u hdfs hdfs namenode -format
	touch /usr/namenodeinstalled
	EOS
end







