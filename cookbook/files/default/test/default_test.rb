require 'minitest/spec'

describe_recipe 'runnable_lebowski::default' do

  include MiniTest::Chef::Assertions
  include Minitest::Chef::Context
  include Minitest::Chef::Resources
  include Chef::Mixin::ShellOut

  it 'installs nodejs v0.10.28' do
    node_version = shell_out('node --version').stdout
    assert_equal("v0.10.28\n", node_version, "Incorrect node version present: #{node_version}")
  end

  it 'installs pm2' do
    assert shell_out('npm list -g pm2').exitstatus == 0
  end

  it 'creates github ssh deploy key files' do
    file('/root/.ssh/runnable_lebowski').must_exist
    file('/root/.ssh/runnable_lebowski.pub').must_exist
  end

  it 'starts api-server service' do
    shell_out('service api-server status').stdout.must_match(/^api-server start\/running, process [0-9]*$/)
  end

  it 'starts cleanup service' do
    shell_out('service cleanup status').stdout.must_match(/^cleanup start\/running, process [0-9]*$/)
  end

end
