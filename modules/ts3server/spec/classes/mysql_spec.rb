require 'spec_helper'

describe 'ts3server::mysql', :type => 'class' do

	context "On a Debian based OS" do
		let :facts do
			{
				:osfamily => 'Debian',
				:architecture => 'amd64'
			}
		end

		it { should include_class("ts3server::params") }
		it { should include_class("ts3server") }
		it { should contain_staging__file('libmysqlclient15off_5.0.96-0ubuntu3_amd64.deb').with(
			'source' => 'http://security.ubuntu.com/ubuntu/pool/main/m/mysql-dfsg-5.0/libmysqlclient15off_5.0.96-0ubuntu3_amd64.deb'
			)
		}
		it { should contain_package("libmysqlclient.so.15").with(
			'ensure' => 'installed',
			'source' => 'libmysqlclient15off_5.0.96-0ubuntu3_amd64.deb',
			'provider' => 'dpkg'
			)
		}
		it { should contain_file("/opt/teamspeak3-server_linux-amd64/mysql.ini").with(
				'ensure' => 'file',
				'owner'  => 'teamspeak',
				'group'  => 'teamspeak'
			)
		}
	end

	context "On a RedHat based OS" do
		let :facts do
			{
				:osfamily => 'RedHat',
				:architecture => 'amd64'
			}
		end

		it { should include_class("ts3server::params") }
		it { should include_class("ts3server") }
		it { should contain_staging__file('libmysqlclient15-5.0.95-5.w5.x86_64.rpm').with(
			'source' => 'http://repo.webtatic.com/yum/centos/5/x86_64/libmysqlclient15-5.0.95-5.w5.x86_64.rpm'
			)
		}
		it { should contain_package("libmysqlclient.so.15").with(
			'ensure' => 'installed',
			'source' => 'libmysqlclient15-5.0.95-5.w5.x86_64.rpm',
			'provider' => 'yum'
			)
		}
		it { should contain_file("/opt/teamspeak3-server_linux-amd64/mysql.ini").with(
				'ensure' => 'file',
				'owner'  => 'teamspeak',
				'group'  => 'teamspeak'
			)
		}
	end
end