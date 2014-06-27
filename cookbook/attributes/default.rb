default['runnable_lebowski']['deploy_path']		= '/opt/lebowski'
default['runnable_lebowski']['config'] = {
  :host => node.ipaddress,
  :port => 3480,
  :redisPort  => '6379',
  :redisHost => search(:node, "chef_environment:#{node.chef_environment} AND recipes:runnable\:\:redis_master").first.ipaddress
}

case node.chef_environment
when 'integration'
  default['runnable_lebowski']['config'] = {
    :domain 	=> 'cloudcosmos.com',
  }
when 'staging'
  default['runnable_lebowski']['config'] = {
    :domain 	=> 'runnable.pw',
  }
when 'production'
  default['runnable_lebowski']['config'] = {
    :domain 	=> 'runnable.com',
    :newrelic	=> {
      :name 	=> 'lebowski-production',
      :key	=> '338516e0826451c297d44dc60aeaf0a0ca4bfead'
    },
  }
else
  throw 'Error: unrecognized chef_environment. Must be one of: integration, staging, production'
end
