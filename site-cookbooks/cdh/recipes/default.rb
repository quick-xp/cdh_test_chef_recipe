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


#Copying the Hadoop Configuration
bash "Copying the Hadoop Configuration" do
	not_if { File.exists?("/etc/hadoop/conf.my_cluster")}
	code <<-EOS
	sudo cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.my_cluster
	sudo update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.my_cluster 50
	sudo update-alternatives --set hadoop-conf /etc/hadoop/conf.my_cluster
	chown -R root:hadoop /etc/hadoop/conf.my_cluster
	EOS
end

#設定ファイル(HDFS)
template "core-site.xml" do
	path "/etc/hadoop/conf.my_cluster/core-site.xml"
	source "core-site_2.xml.erb"
	owner "root"
	group "hadoop"
	mode 00644
end

template "hdfs-site.xml" do
	path "/etc/hadoop/conf.my_cluster/hdfs-site.xml"
	source "hdfs-site_2.xml.erb"
	owner "root"
	group "hadoop"
	mode 00644
end

#hdfsデータ格納用フォルダ作成
directory "/data" do
	owner "hdfs"
	group "hadoop"
	mode 00774
	action :create
end

directory "/data/1" do
	owner "hdfs"
	group "hadoop"
	mode 00774
	action :create
end

directory "/data/1/dfs" do
	owner "hdfs"
	group "hadoop"
	mode 00744
	action :create
end

directory "/data/1/dfs/nn" do
	owner "hdfs"
	group "hadoop"
	mode 00744
	action :create
end

directory "/data/1/dfs/dn" do
	owner "hdfs"
	group "hadoop"
	mode 00744
	action :create
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

#Service起動
service "hadoop-hdfs-namenode" do
	action :restart
end

service "hadoop-hdfs-datanode" do
	action :restart
end

#設定ファイル(YARN)
template "mapred-site.xml" do
	path "/etc/hadoop/conf.my_cluster/mapred-site.xml"
	source "mapred-site_2.xml.erb"
	owner "root"
	group "hadoop"
	mode 00644
end

template "yarn-site.xml" do
	path "/etc/hadoop/conf.my_cluster/yarn-site.xml"
	source "yarn-site.xml.erb"
	owner "root"
	group "hadoop"
	mode 00644
end

#yarnデータ格納用フォルダ作成
directory "/data/1/yarn" do
	owner "yarn"
	group "yarn"
	mode 00755
	action :create
end

directory "/data/1/yarn/local" do
	owner "yarn"
	group "yarn"
	mode 00755
	action :create
end

directory "/data/1/yarn/logs" do
	owner "yarn"
	group "yarn"
	mode 00755
	action :create
end

#yarn.nodemanager.remote-app-log-dir用のhdfsディレクトリ作成
bash "create hdfs directory for app-log" do
        code <<-EOS
	sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn/apps
	sudo -u hdfs hadoop fs -chown -R yarn:hadoop /var/log/hadoop-yarn
	sudo -u hdfs hadoop fs -chmod -R 1774 /var/log/hadoop-yarn
	EOS
	not_if "sudo -u hdfs hadoop fs -test -d /var/log/hadoop-yarn/apps"
end

#hdfs上にtmpディレクトリ作成
bash "create tmp directory on hdfs" do
        code <<-EOS
	sudo -u hdfs hadoop fs -mkdir /tmp
	sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
	EOS
	not_if "sudo -u hdfs hadoop fs -test -d /tmp"
end

#hdfs上にHistory用ディレクトリ作成
bash "create history directory on hdfs" do
        code <<-EOS
	sudo -u hdfs hadoop fs -mkdir -p /user/history
	sudo -u hdfs hadoop fs -chown -R yarn:hadoop /user/history
	sudo -u hdfs hadoop fs -chmod -R 1777 /user/history
	EOS
	not_if "sudo -u hdfs hadoop fs -test -d /user/history"
end

#Service起動
service "hadoop-yarn-resourcemanager" do
	action :restart
end

service "hadoop-yarn-nodemanager" do
	action :restart
end

service "hadoop-mapreduce-historyserver" do
	action :restart
end

