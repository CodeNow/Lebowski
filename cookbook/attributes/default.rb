default['runnable_lebowski']['deploy_path']		= '/opt/lebowski'
default['runnable_lebowski']['config'] = {
  'host' => node.ipaddress,
  'port' => 3480,
  'redisPort'  => '6379'
}

