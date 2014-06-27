default['runnable_lebowski']['deploy_path']		= '/opt/lebowski'

case node.chef_environment
when 'integration'
  default['runnable_lebowski']['config'] = {
    :domain 	=> 'cloudcosmos.com',
    :host	=> '10.0.1.191',
    :port	=> 3480,
    :redisPort	=> '6379',
    :redisHost	=> '10.0.1.14'
  }
when 'staging'
  default['runnable_lebowski']['config'] = {
    :domain 	=> 'runnable.pw',
    :host	=> '10.0.1.9',
    :port	=> 3480,
    :redisPort	=> '6379',
    :redisHost	=> '10.0.1.125'
  }
when 'production'
  default['runnable_lebowski']['config'] = {
    :domain 	=> 'runnable.com',
    :host	=> '10.0.1.191',
    :port	=> 3480,
    :newrelic	=> {
      :name 	=> 'lebowski-production',
      :key	=> '338516e0826451c297d44dc60aeaf0a0ca4bfead'
    },
    :redisPort	=> '6379',
    :redisHost	=> '10.0.1.14'
  }
else
  throw 'Error: unrecognized chef_environment. Must be one of: integration, staging, production'
end
