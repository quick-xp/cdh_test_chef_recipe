#
# Cookbook Name:: hadoop
# Recipe:: default
#
#http://symfoware.blog68.fc2.com/blog-entry-1196.html
URL = node["hadoop"]["url"]
HadoopFileName = node["hadoop"]["filename"]

group "hadoop" do
	group_name "hadoop"
	action [:create]
end

user "hadoop" do
	group "hadoop"
	home "/home/hadoop"
	password nil
	shell "/bin/bash"
	supports :manage_home => true
	action   [:create]
end

directory "/usr/local/hadoop" do
	owner "hadoop"
	group "hadoop"
	mode 00764
	action :create
end

directory "/var/hdfs" do
	owner "hadoop"
	group "hadoop"
	mode 00764
	action :create
end

directory "/var/hdfs/namenode" do
	owner "hadoop"
	group "hadoop"
	mode 00764
	action :create
end

directory "/var/hdfs/datanode" do
	owner "hadoop"
	group "hadoop"
	mode 00764
	action :create
end

package "ssh"

bash "get-hadoop-file" do
	not_if { File.exists?("/usr/local/src/"+HadoopFileName+".tar.gz")}
	code <<-EOS
	cd /usr/local/src
	wget #{URL}
	tar zxf #{HadoopFileName}.tar.gz
	mv #{HadoopFileName} hadoop
	mv /usr/local/src/hadoop /usr/local
	chown -R hadoop:hadoop /usr/local/hadoop
	EOS
end

template ".bashrc" do
	path "/home/hadoop/.bashrc"
	source "bashrc.erb"
	owner "hadoop"
	group "hadoop"
	mode 00744
end

template "yarn-site.xml" do
	path "/usr/local/hadoop/etc/hadoop/yarn-site.xml"
	source "yarn-site.xml.erb"
	owner "hadoop"
	group "hadoop"
	mode 00744
end

template "hdfs-site.xml" do
	path "/usr/local/hadoop/etc/hadoop/hdfs-site.xml"
	source "hdfs-site.xml.erb"
	owner "hadoop"
	group "hadoop"
	mode 00744
end

template "core-site.xml" do
	path "/usr/local/hadoop/etc/hadoop/core-site.xml"
	source "core-site.xml.erb"
	owner "hadoop"
	group "hadoop"
	mode 00744
end

template "mapred-site.xml" do
	path "/usr/local/hadoop/etc/hadoop/mapred-site.xml"
	source "mapred-site.xml.erb"
	owner "hadoop"
	group "hadoop"
	mode 00744
end


directory "/usr/local/hadoop" do
	owner "hadoop"
	group "hadoop"
	mode 00764
	action :create
end

#hdfs node のフォーマット
execute "hdfs-namenode-format" do
  command "hdfs namenode -format"
  action :nothing
  group "hdfs"
  user "hdfs"
end
