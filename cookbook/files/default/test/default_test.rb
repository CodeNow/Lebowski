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

  it 'configures lebowski' do
    assert_includes_content('/opt/lebowski/current/configs/integration.json', node['lebowski']['deploy']['config'].to_json)
  end

  it 'starts lebowski' do
    assert shell_out('pgrep Lebowski').exitstatus == 0
  end

  it 'listens on port 3480' do
    assert shell_out('lsof -n -i :3480').exitstatus == 0
  end

end
