require 'spec_helper'

describe 'ts3server', :type => 'class' do

	context "amd64 architecture" do
		let :facts do
			{
				:osfamily     => 'Debian',
				:architecture => 'amd64',
			}
		end

		let(:params) { { :version => '3.0.7.2' } }

		it { should include_class("ts3server::params") }
 		it { should contain_package("screen") }
 		it { should contain_user("teamspeak") }
 		it { should contain_group("teamspeak") }
 		it { should contain_staging__file('teamspeak3-server_linux-amd64-3.0.7.2.tar.gz').with(
 			'source' => 'http://ftp.4players.de/pub/hosted/ts3/releases/3.0.7.2/teamspeak3-server_linux-amd64-3.0.7.2.tar.gz'
 			)
 		}
 		it { should contain_staging__extract('teamspeak3-server_linux-amd64-3.0.7.2.tar.gz').with(
 			'target' => '/opt',
 			'creates' => '/opt/teamspeak3-server_linux-amd64'
 			)
 		}
 		it { should contain_file("/opt/teamspeak3-server_linux-amd64").with(
 			'ensure'  => 'directory',
 			'recurse' => 'true',
 			'owner' 	=> 'teamspeak',
 			'group' 	=> 'teamspeak'
 			)
 		}
 		it { should contain_file("/opt/teamspeak3-server_linux-amd64/ts3server.ini").with(
 			'ensure' => 'file',
 			'owner'  => 'teamspeak',
 			'group'  => 'teamspeak'
 			)
 		}
 		it { should contain_file("/etc/init.d/teamspeak").with(
 			'ensure' => 'file',
 			'mode'   => '0755',
 			'owner'  => 'root',
 			'group'  => 'root',
 			)
 		}
 		it { should contain_service("teamspeak").with(
 			'enable' => 'true',
 			'ensure' => 'running',
 			)
 		}
 	end

 	context "x86 architecture" do
		let :facts do
			{
				:osfamily     => 'Debian',
				:architecture => 'x86',
			}
		end

		let(:params) { { :version => '3.0.7.2' } }

		it { should include_class("ts3server::params") }
 		it { should contain_package("screen") }
 		it { should contain_user("teamspeak") }
 		it { should contain_group("teamspeak") }
 		it { should contain_staging__file('teamspeak3-server_linux-x86-3.0.7.2.tar.gz').with(
 			'source' => 'http://ftp.4players.de/pub/hosted/ts3/releases/3.0.7.2/teamspeak3-server_linux-x86-3.0.7.2.tar.gz'
 			)
 		}
 		it { should contain_staging__extract('teamspeak3-server_linux-x86-3.0.7.2.tar.gz').with(
 			'target' => '/opt',
 			'creates' => '/opt/teamspeak3-server_linux-x86'
 			)
 		}
 		it { should contain_file("/opt/teamspeak3-server_linux-x86").with(
 			'ensure'  => 'directory',
 			'recurse' => 'true',
 			'owner' 	=> 'teamspeak',
 			'group' 	=> 'teamspeak'
 			)
 		}
 		it { should contain_file("/opt/teamspeak3-server_linux-x86/ts3server.ini").with(
 			'ensure' => 'file',
 			'owner'  => 'teamspeak',
 			'group'  => 'teamspeak'
 			)
 		}
 		it { should contain_file("/etc/init.d/teamspeak").with(
 			'ensure' => 'file',
 			'mode'   => '0755',
 			'owner'  => 'root',
 			'group'  => 'root',
 			)
 		}
 		it { should contain_service("teamspeak").with(
 			'enable' => 'true',
 			'ensure' => 'running',
 			)
 		}
	end
 end