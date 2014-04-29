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

package 'hadoop-yarn-resourcemanager' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-hdfs-namenode' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-yarn-nodemanager' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-hdfs-datanode' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-mapreduce' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-mapreduce-historyserver' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-yarn-proxyserver' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-client' do
	options "-f --force-yes"
	action :install
end

#最初の一回しか実行できません。
#2回目以降は手動でコマンドを実行してください
bash "node format" do
	not_if { File.exists?("/usr/namenodeinstalled")}
	code <<-EOS
	sudo -u hdfs hadoop namenode -format
	touch /usr/namenodeinstalled
	EOS
end




